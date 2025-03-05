using System;
using System.Collections.Generic;
using QuanLyTaiSan_UserManagement.Common;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace QuanLyTaiSan_UserManagement.Controllers
{
    public class BaseController : Controller
    {

        public void AlertMessage(string mess)
        {
            string messAlert = "<script>alert(" + "'" + mess + "'" + ");</script>";
            Response.Write(messAlert);
        }


        public UserLoginSec LoginUserSession
        {

            get
            {
                try
                {
                    return (UserLoginSec)HttpContext.Session[CommonConstants.USER_SESSION];
                }
                catch
                {
                    return new UserLoginSec();
                }

            }
            set
            {

                Session.Add(CommonConstants.USER_SESSION, value);
            }
        }
        public List<string> RoleUserSession
        {

            get
            {
                try
                {
                    return (List<string>)HttpContext.Session[CommonConstants.SESSION_CREDENTIALS];
                }
                catch
                {
                    return new List<string>();
                }

            }
            set
            {

                Session.Add(CommonConstants.SESSION_CREDENTIALS, value);
            }
        }

        public void logs(string typeLogs, string controllerName, string methodName, string messErr)
        {
            QLogs logs = new QLogs();
            string Mess = controllerName + "/" + methodName + ": " + messErr;
            if (typeLogs == "ERRO")
            {
                logs.Error(Mess);
            }
            if (typeLogs == "INFO")
            {
                logs.Info(Mess);
            }
            if (typeLogs == "WARN")
            {
                logs.Warning(Mess);
            }

        }



    }
}