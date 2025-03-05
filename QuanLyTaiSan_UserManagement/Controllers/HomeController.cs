using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using QuanLyTaiSan_UserManagement.Models;
using QuanLyTaiSan_UserManagement.Attribute;
using System;
using QuanLyTaiSan_UserManagement.Common;

namespace QuanLyTaiSan_UserManagement.Controllers
{
    // [Authorize]
    //[AuthorizationHandler]
    public class HomeController : Controller
    {
        QuanLyTaiSanCtyEntities data = new QuanLyTaiSanCtyEntities();
        public ActionResult Index()
        {
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];
            
            int? departmetnId = -1;

            if (session.GroupID == "MANAGER" || session.GroupID == "DIRECTOR")
            {
                departmetnId = Int32.Parse(data.UserLogins.Where(x => x.UserName == session.UserName).Select(x => x.Email).FirstOrDefault() ?? "0");
            }

            var ListCount = new Dictionary<string, int>();
            int CountDevice = data.SearchDevice(null, null, null, departmetnId, null, session.UserName).Where(x => x.Status != 2).Count();
            ListCount.Add("CountDevice", CountDevice);
            int Deviceliquidation = data.SearchDevice(null, null, null, departmetnId, null, session.UserName).Where(x => x.Status == 2).Count();
            ListCount.Add("Deviceliquidation", Deviceliquidation);
            int DeviceType = data.DeviceTypes.Count();
            ListCount.Add("DeviceType", DeviceType);
            int Project = data.ProjectDKCs.Where(x => x.IsDeleted == false & x.TypeProject == 1 && (departmetnId == null || x.Id == departmetnId)).Count();
            ListCount.Add("Project", Project);
            int User = data.Users.Where(x => x.IsDeleted == false).Count();
            ListCount.Add("User", User);
            int RequestDevice = data.RequestDevices.Count();
            ListCount.Add("RequestDevice", RequestDevice);
            ViewData["TypeOfDevice"] = data.DeviceTypes.ToList();
            return View(ListCount);
        }
        [Authorize(Roles = "Administrator")]
        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";
            return View();
        }

        [Authorize(Roles = "StandardUser")]
        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";
            return View();
        }

        [AllowAnonymous]
        public ActionResult Unauthorized()
        {
            return View();
        }

        [HttpGet]
        [AllowAnonymous]
        public ActionResult GetData_PieChart()
        {
            var result_lst = data.GetData_PieChart();
            var _result = new { result = true, result_con = result_lst };
            return Json(_result, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        [AllowAnonymous]
        public ActionResult GetData_HorizontalChart()
        {
            var result_lst = data.GetData_HorizontalChart();
            var _result = new { result = true, result_con = result_lst };
            return Json(_result, JsonRequestBehavior.AllowGet);
        }
        
    }
}