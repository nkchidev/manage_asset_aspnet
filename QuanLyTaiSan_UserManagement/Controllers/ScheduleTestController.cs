using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;
using QuanLyTaiSan_UserManagement.Attribute;
using QuanLyTaiSan_UserManagement.Helper;
using QuanLyTaiSan_UserManagement.Models;

namespace QuanLyTaiSan_UserManagement.Controllers
{

    public class ScheduleTestController : Controller
    {

        QuanLyTaiSanCtyEntities Ql = new QuanLyTaiSanCtyEntities();

        [HasCredential(RoleID = "VIEW_SCHEDULETEST")]
        public ActionResult ScheduleTest()
        {
            ViewData["User"] = Ql.Users.ToList();
            ViewData["ScheduleTests"] = Ql.ScheduleTests.ToList();
            ViewData["Devices"] = Ql.Devices.Where(x => x.IsDeleted != true).ToList();
            var lstScheduleTests = Ql.SearchScheduleTest(null, null, null, null).ToList().OrderByDescending(k => k.Id);
            return View(lstScheduleTests);
        }

        [HttpPost]
        public ActionResult SeachScheduleTest(FormCollection colection, RepairDetail RepairDetails)
        {
            ViewData["User"] = Ql.Users.ToList();
            ViewData["ScheduleTests"] = Ql.ScheduleTests.ToList();
            ViewData["Devices"] = Ql.Devices.Where(x => x.IsDeleted != true).ToList();
            int? DeviceId = colection["DeviceId"].Equals("") ? (int?)null : Convert.ToInt32(colection["DeviceId"]);
            int? Users = colection["User"].Equals("") ? (int?)null : Convert.ToInt32(colection["User"]);
            int? Status = colection["Status"].Equals("") ? (int?)null : Convert.ToInt32(colection["Status"]);
            int? Status_tt = colection["Status_tt"].Equals("") ? (int?)null : Convert.ToInt32(colection["Status_tt"]);
            var lstScheduleTest = Ql.SearchScheduleTest(Users, Status, Status_tt, DeviceId).ToList().OrderByDescending(k => k.Id);
            var ViewScheduleTest = lstScheduleTest;
            ViewBag.Users = Users;
            ViewBag.Status = Status;
            ViewBag.Status_tt = Status_tt;
            ViewBag.DeviceId = DeviceId;
            return View("ScheduleTest", lstScheduleTest);
        }
        [HasCredential(RoleID = "ADD_SCHEDULETEST")]
        public ActionResult AddScheduleTest()
        {
            ViewData["Devices"] = Ql.Devices.Where(x => x.IsDeleted != true).ToList();
            ViewData["User"] = Ql.Users.Where(x => x.Status != 1 && x.IsDeleted != true).ToList();
            return View();
        }
        [HasCredential(RoleID = "ADD_SCHEDULETEST")]
        [HttpPost]
        public ActionResult AddScheduleTest(FormCollection colection, ScheduleTest ScheduleTest)
        {
            int? DeviceId = colection["DeviceId"].Equals("") ? (int?)null : Convert.ToInt32(colection["DeviceId"]);
            int? CycleTest = colection["CycleTest"].Equals("") ? (int?)null : Convert.ToInt32(colection["CycleTest"]);
            DateTime? DateOfTest = colection["DateOfTest"].Equals("") ? (DateTime?)null : Convert.ToDateTime(colection["DateOfTest"]);
            DateTime? NextDateOfTest = colection["NextDateOfTest"].Equals("") ? (DateTime?)null : Convert.ToDateTime(colection["NextDateOfTest"]);
            String CategoryTest = colection["CategoryTest"];
            int? UserTest = colection["UserTest"].Equals("0") ? (int?)null : Convert.ToInt32(colection["UserTest"]);
            String Notes = colection["Notes"];
            String CompanyTest = colection["CompanyTest"];
            Ql.AddScheduleTest(DeviceId, DateOfTest, NextDateOfTest, CategoryTest, UserTest, Notes, CompanyTest, CycleTest);
            return RedirectToAction("ScheduleTest", "ScheduleTest");
        }
        [HasCredential(RoleID = "EDIT_SCHEDULETEST")]
        public ActionResult EditScheduleTest(int Id)
        {
            var dvId = Ql.ScheduleTests.Find(Id).DeviceId;
            ViewData["historyScheduleTests"] = Ql.HistoryScheduleTestById(dvId).ToList();
            ViewData["User"] = Ql.Users.Where(x => x.Status != 1 && x.IsDeleted != true).ToList();
            var lstSchedule = Ql.ScheduleTestById(Id).Single();
            return View(lstSchedule);
        }
        [HasCredential(RoleID = "EDIT_SCHEDULETEST")]
        [HttpPost]
        public ActionResult EditScheduleTest(FormCollection colection, ScheduleTest ScheduleTest)
        {
            int? Id = colection["Id"].Equals("") ? (int?)null : Convert.ToInt32(colection["Id"]);
            int? DeviceId = colection["DeviceId"].Equals("") ? (int?)null : Convert.ToInt32(colection["DeviceId"]);
            //var dateot = colection["DateOfTest"];
            DateTime? DateOfTest = colection["DateOfTest"].Equals("") ? (DateTime?)null : Convert.ToDateTime(colection["DateOfTest"]);
            DateTime? NextDateOfTest = colection["NextDateOfTest"].Equals("") ? (DateTime?)null : Convert.ToDateTime(colection["NextDateOfTest"]);
            String CategoryTest = colection["CategoryTest"];
            int? UserTest = colection["UserTest"].Equals("0") ? (int?)null : Convert.ToInt32(colection["UserTest"]);
            String Notes = colection["Notes"];
            String CompanyTest = colection["CompanyTest"];
            int? Status = colection["Status"].Equals("") ? (int?)null : Convert.ToInt32(colection["Status"]);
            Ql.UpdateScheduleTest(Id, DeviceId, DateOfTest, NextDateOfTest, CategoryTest, UserTest, Notes, Status, CompanyTest);
            return RedirectToAction("EditScheduleTest", "ScheduleTest");

        }
        [HasCredential(RoleID = "DELETE_SCHEDULETEST")]
        public JsonResult DeleteScheduleTest(string Id)
        {
            string a = "," + Id + ",";
            bool result = false;
            int checkdele = Ql.DeleteScheduleTest(a);
            if (checkdele > 0)
                result = true;
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult AddMonth(string _DateOfTest, int _CycleTest)
        {
            bool _rs;
            string dateFeauture = "";
            try
            {
                DateTime dateTest = DateTime.ParseExact(_DateOfTest, "yyyy-MM-dd", CultureInfo.InvariantCulture);
                dateFeauture = dateTest.AddMonths(_CycleTest).ToString("yyyy-MM-dd");
                _rs = true;
                var result = new { _rs, dateFeauture };
                return Json(result, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                _rs = false;
                var result = new { _rs, dateFeauture };
                return Json(result, JsonRequestBehavior.AllowGet);
            }


        }
        [HasCredential(RoleID = "EXPORT_SCHEDULETEST")]
        public JsonResult ExportScheduleTest(int? DeviceId, int? User, int? Status, int? Status_tt)
        {
            Ql.Configuration.ProxyCreationEnabled = false;

            var lstScheduleTest = Ql.SearchScheduleTest(User, Status, Status_tt, DeviceId).ToList();
            List<NewConfig> numbers = new List<NewConfig>();
            for (int i = 0; i < lstScheduleTest.Count; ++i)
            {
                var status = lstScheduleTest[i].Status.GetEnumDescription(typeof(eStatus.StatusScheduleTest));
                var status_tt = lstScheduleTest[i].Status_tt.GetEnumDescription(typeof(eStatus.Tinhtrang_lichkiemtra));
                var DateOfTest = @String.Format("{0:dd/MM/yyyy}", lstScheduleTest[i].DateOfTest);
                var CreateDate = @String.Format("{0:dd/MM/yyyy}", lstScheduleTest[i].CreateDate);
                var NextDateOfTest = @String.Format("{0:dd/MM/yyyy}", lstScheduleTest[i].NextDateOfTest);
                numbers.Add(new NewConfig { DeviceCode = lstScheduleTest[i].DeviceCode, DeviceName = lstScheduleTest[i].DeviceName, CategoryTest = lstScheduleTest[i].CategoryTest, CreateDate = CreateDate, DateOfTest = DateOfTest, FullName = lstScheduleTest[i].FullName, CompanyTest = lstScheduleTest[i].CompanyTest, Notes = lstScheduleTest[i].Notes, Status = status, NextDateOfTest = NextDateOfTest, Status_tt = status_tt, CycleTest = lstScheduleTest[i].CycleTest.ToString() });
            }

            using (StringWriter sw = new StringWriter())
            {
                using (System.Web.UI.HtmlTextWriter htw = new System.Web.UI.HtmlTextWriter(sw))
                {
                    GridView grid = new GridView();
                    grid.DataSource = numbers;
                    grid.DataBind();
                    Response.ClearContent();
                    Response.Buffer = true;
                    string strDateFormat = string.Empty;
                    strDateFormat = string.Format("{0:dd/MM/yyyy}", DateTime.Now);
                    Response.AddHeader("content-disposition", "attachment; filename=PhongBan_" + strDateFormat + ".xlxs");
                    Response.ContentType = "application/ms-excel";
                    Response.Charset = "";
                    grid.RenderControl(htw);
                    Response.Output.Write(sw.ToString());
                    Response.End();
                    ViewBag.Sw = sw;

                }
            }
            return Json(new
            {
                ViewBag.Sw,
            }, JsonRequestBehavior.AllowGet);
        }
        public class NewConfig
        {
            public string DeviceCode { get; set; }
            public string DeviceName { get; set; }
            public string CategoryTest { get; set; }
            public string CreateDate { get; set; }
            public string DateOfTest { get; set; }
            public string FullName { get; set; }
            public string CompanyTest { get; set; }
            public string Notes { get; set; }
            public string Status { get; set; }
            public string NextDateOfTest { get; set; }
            public string Status_tt { get; set; }
            public string CycleTest { get; set; }

        }

    }
}