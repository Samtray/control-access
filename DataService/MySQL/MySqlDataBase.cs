using System;
using System.Data;
using MySql.Data;
using MySql.Data.MySqlClient;

namespace DataService.MySQL
{
    public class MySqlDataBase {
        /*
        Pending to add 
            Reconnect Feature, sets a timer to reconnect
            Safe Block - transaction implementation (Should be complete right now)       
        */

        // Delegates
        public delegate void TransactionCallback(MySqlTransaction txn);
        public delegate void DataException(Exception e, string customMsg = "");
        public delegate void ReaderAction(IDataReader reader);

        // Properties
        public static DataException? OnException { get; set; }
        public MySqlConnection Connection { get; set; } = new MySqlConnection();
        private string? ConnectionString { get; set; }

        // Constructor
        public MySqlDataBase(string? connString) {
            try {
                ConnectionString = connString;
                OpenConnection();
            } catch (Exception ex) {
                if (OnException != null) {
                    if (ex.GetType() == typeof(MySqlException)) {
                        MySqlException e = (MySqlException)ex;
                        switch (e.Number) {
                            case 0:
                                OnException(ex, "Cannot connect to server.  Contact administrator");
                                break;
                            case 1045:
                                OnException(ex, "Invalid username/password, please try again");
                                break;
                        }
                    } else {
                        OnException(ex, "Exception creating connection...");
                    }
                }
            }
        }

        public void OpenConnection() => OpenConnection(this);

        public void CloseConnection() {
            if (Connection.State == ConnectionState.Open) {
                Connection.Close();
                Connection.Dispose();
            }
        }

        public MySqlCommand CreateCommand(string cmdText, MySqlTransaction txn, CommandType type)
        => CreateCommand(cmdText, Connection, txn, type);

        // Static Methods
        private void OnStateChange(object obj, StateChangeEventArgs args) {
            if (args.CurrentState == ConnectionState.Closed) {
                //OpenConnection();
            }
        }

        public static MySqlCommand CreateCommand(string cmdText, MySqlConnection conn, MySqlTransaction txn, CommandType type)
        => new MySqlCommand(cmdText, conn, txn) {
            CommandType = type
        };

        public static IDataParameter CreateParameter(string name, object? value, MySqlDbType type, bool isNullable = true) => new MySqlParameter(name, value) {
            Direction = ParameterDirection.Input,
            MySqlDbType = type,
            IsNullable = isNullable
        };

        public static IDataParameter CreateParameterOut(string name, MySqlDbType type) => new MySqlParameter() {
            ParameterName = name,
            Direction = ParameterDirection.Output,
            MySqlDbType = type
        };

        private static void OpenConnection(MySqlDataBase db)
        {
            if (string.IsNullOrEmpty(db.ConnectionString))
            {
                throw new Exception("MySQL Connection string is empty");
            }

            db.Connection = new MySqlConnection(db.ConnectionString);
            db.Connection.StateChange += db.OnStateChange;            
            db.Connection.Open();
        }

        public static void ReaderBlock(MySqlCommand cmd, ReaderAction action) 
        {
            using var reader = cmd.ExecuteReader();
            action(reader);
            reader.Close();
        }        

        public static void NonQueryBlock(MySqlCommand cmd, Action action)
        {
            cmd.ExecuteNonQuery();
            action();
        }

        public static void TransactionBlock(
            MySqlDataBase db, 
            TransactionCallback action, 
            DataException onException,
            Action? onProcess = null
        ) {
            MySqlTransaction? txn = null;
            MySqlConnection conn = db.Connection;
            bool isTxnSuccess;

            try {
                if (conn.State == ConnectionState.Open)
                {
                    db.Connection.Close();
                    db.Connection.Dispose();
                }

                OpenConnection(db);

                txn = conn.BeginTransaction();                
                action(txn);
                txn.Commit();
                isTxnSuccess = true;
            } catch (Exception e) {
                if(txn != null)
                    txn.Rollback();
                onException(e);

                isTxnSuccess = false;
            }

            if (isTxnSuccess)
                onProcess?.Invoke();

            if (txn != null)
                txn.Dispose();

        }
    }
}