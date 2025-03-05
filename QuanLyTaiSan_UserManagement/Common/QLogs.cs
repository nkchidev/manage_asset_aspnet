using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using QuanLyTaiSan_UserManagement.Controllers;
using System.Configuration;

namespace QuanLyTaiSan_UserManagement.Common
{
    public class QLogs
    {
        #region Enum 
        public enum LogType
        {
            Error,
            Warn,
            Info
        }
        #endregion

        #region Constants
        //  private string sLogFolderName = "C:/QLTS_LOGS";
        private string sLogFolderName = ConfigurationManager.AppSettings["LOG_FOLDER"].ToString();
   
        #endregion

        #region Static Constructor
        public QLogs()
        {
            if (!Directory.Exists(sLogFolderName))
            {
                Directory.CreateDirectory(sLogFolderName);
            }
        }
        #endregion

        #region Public functioncs
        public void Error(string message)
        {
            WriteEntry(message, LogType.Error);
        }
        public void ErrorException(Exception ex)
        {
            string message = string.Format("{0}. TRACE: {1}", ex.Message, ex.StackTrace);
            WriteEntry(message, LogType.Error);
        }
        public void Warning(string message)
        {
            WriteEntry(message, LogType.Warn);
        }
        public void Info(string message)
        {
            WriteEntry(message, LogType.Info);
        }

        private void WriteEntry(string message, LogType logType)
        {
            string strFileName = BuildFileName();

            string str = string.Format("{0} : {1} : {2}",
                DateTime.Now.ToString("dd/MM/yyyy hh:mm:ss"),
                GetLogTypeStr(logType),
                message);

            StreamWriter writer = new StreamWriter(strFileName, true);
            writer.WriteLine(str);
            writer.Close();
        }

        private string GetLogTypeStr(LogType logType)
        {
            switch (logType)
            {
                case LogType.Error: return "ERROR";
                case LogType.Warn: return "WARN ";
                case LogType.Info: return "INFO ";
            }
            return "";
        }

        private string BuildFileName()
        {
            UserLoginSec UserLoginSecssion = (UserLoginSec)HttpContext.Current.Session[CommonConstants.USER_SESSION];
            string userName = UserLoginSecssion == null ? "" : UserLoginSecssion.UserName.Trim();
            string strFileName = string.Format("{0}_{1}.log",
                DateTime.Now.ToString("ddMMyyyy"), userName);
            return sLogFolderName + @"\" + strFileName;
        }

        #endregion
    }
}