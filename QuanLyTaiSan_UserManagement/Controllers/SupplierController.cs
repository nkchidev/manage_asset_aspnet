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
    //  [Authorize]
    //  [AuthorizationHandler]
    public class SupplierController : Controller
    {
        //public SupplierController()
        //{
        //}

        //public SupplierController(QLogs _log) : base(_log)
        //{
        //}

        QuanLyTaiSanCtyEntities data = new QuanLyTaiSanCtyEntities();
        // GET: Supplier
        //  [AuthorizationViewHandler]
        [HasCredential(RoleID = "VIEW_SUPPLIER")]
        public ActionResult Supplier()
        {
            ViewData["Supplier"] = data.Suppliers.ToList();
            return View(data.Suppliers.ToList());
        }
        //[AuthorizationViewHandler]
        [HasCredential(RoleID = "EDIT_SUPPLIER")]
        public ActionResult EditSupplier(int Id)
        {
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];
            ViewData["sDevice"] = data.SearchDevice(null, null, null, null, null, session.UserName).Where(x => x.SupplierId == Id).ToList();
            return View(data.Suppliers.Find(Id));
        }
        [HttpPost]
        [ValidateInput(false)]
        [HasCredential(RoleID = "EDIT_SUPPLIER")]
        public ActionResult EditSupplier(FormCollection collection)
        {
            int Id = Convert.ToInt32(collection["Id"]);
            string Name = collection["Name"];
            string Email = collection["Email"];
            string PhoneNumber = collection["PhoneNumber"];
            string Address = collection["Address"];
            string Support = collection["Support"];
            int Status = Convert.ToInt32(collection["Status"]);
            data.UpdateSupplier(Id, Name, Email, PhoneNumber, Address, Support, Status);
            return RedirectToAction("Supplier", "Supplier");
        }
        [HttpPost]
        [ValidateInput(false)]
        [HasCredential(RoleID = "ADD_SUPPLIER")]
        public ActionResult AddSupplier(FormCollection collection)
        {
            string Name = collection["Name"];
            string Email = collection["Email"];
            string PhoneNumber = collection["PhoneNumber"];
            string Address = collection["Address"];
            string Support = collection["Position"];
            data.AddSupplier(Name, Email, PhoneNumber, Address, Support);
            return RedirectToAction("Supplier", "Supplier");
        }
        [HasCredential(RoleID = "DELETE_SUPPLIER")]
        public JsonResult DeleteSupplier(int Id)
        {
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];
            bool result = false;
            var charts = data.SearchDevice(null, null, null, null, null, session.UserName).Where(x => x.SupplierId == Id).ToList();
            if (charts.Count == 0)
            {
                data.DeleteSupplier(Id);
                result = true;
            }
            else result = false;
            return Json(result, JsonRequestBehavior.AllowGet);
        }
    }
}