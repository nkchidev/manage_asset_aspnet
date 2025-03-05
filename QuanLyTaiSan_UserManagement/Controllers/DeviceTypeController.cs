using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using QuanLyTaiSan_UserManagement.Attribute;
using QuanLyTaiSan_UserManagement.Common;
using QuanLyTaiSan_UserManagement.Models;
namespace QuanLyTaiSan_UserManagement.Controllers
{

    public class DeviceTypeController : Controller
    {
        QuanLyTaiSanCtyEntities data = new QuanLyTaiSanCtyEntities();

        public ActionResult DeviceType()
        {
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];

            int departmetnId = -1;

            if (session.GroupID == "ADMIN")
            {

            }
            else
            {
                departmetnId = Int32.Parse(data.UserLogins.Where(x => x.UserName == session.UserName).Select(x => x.Email).FirstOrDefault() ?? "0");
            }

            var listDevice = data.SearchDevice(null, null, null, departmetnId, null, session.UserName).ToList();
            var listDeviceTyps = data.DeviceTypes.ToList().Where(e => listDevice.Select(x => x.TypeName).Distinct().ToArray().Contains(e.TypeName)).ToList();
            ViewData["DeviceTypes"] = listDeviceTyps;
            return View(listDeviceTyps);
        }
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult AddDeviceType(FormCollection collection)
        {
            string TypeName = collection["TypeName"];
            string Notes = collection["Notes"];
            string TypeSymbol = collection["TypeSymbol"];
            data.AddDeviceType(TypeName, TypeSymbol, Notes);
            return RedirectToAction("DeviceType", "DeviceType");
        }
        [HttpGet]
        public JsonResult GetDetail(int id)
        {
            data.Configuration.ProxyCreationEnabled = false;
            var DeviceType = data.DeviceTypes.Find(id);
            return Json(new
            {
                data = DeviceType,
            }, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        [ValidateInput(false)]
        public JsonResult EditDeviceType(int Id, string TypeName, string TypeSymbol, string Notes)
        {
            bool result = true;
            data.UpdateDeviceType(Id, TypeName, TypeSymbol, Notes);
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        public JsonResult DeleteDeviceType(int Id)
        {
            bool result = false;
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];
            var check_dv = data.SearchDevice(null, Id, null, null, null, session.UserName).ToList().Count(); // Check còn thiết bị thuộc loại.
            var check_sp = data.SearchDeviceSparePart(Id, null).ToList().Count(); // Check còn phụ tùng thuộc loại.
            if (check_dv == 0 && check_sp == 0)
            {
                int checkdele = data.DeleteDeviceType(Id);
                result = true;
            }
            else result = false;
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        //  [AuthorizationViewHandler]
        public ActionResult StatisticalDeviceType()
        {
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];

            int departmetnId = -1;

            if (session.GroupID == "ADMIN")
            {

            }
            else
            {
                departmetnId = Int32.Parse(data.UserLogins.Where(x => x.UserName == session.UserName).Select(x => x.Email).FirstOrDefault() ?? "0");
            }

            var listDevice = data.SearchDevice(null, null, null, departmetnId, null, session.UserName).ToList();

            var listDeviceTyps = data.DeviceTypes.ToList().Where(e => listDevice.Select(x => x.TypeName).Distinct().ToArray().Contains(e.TypeName)).ToList();

            ViewData["DeviceTypes"] = listDeviceTyps;
            return View(listDeviceTyps);
        }
    }
}