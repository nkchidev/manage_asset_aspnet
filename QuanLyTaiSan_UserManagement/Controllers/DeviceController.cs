using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using QuanLyTaiSan_UserManagement.Models;
using System.ComponentModel;
using QuanLyTaiSan_UserManagement.Attribute;
using System.IO;
using System.Drawing;
using System.Drawing.Imaging;
using System.Runtime.InteropServices;
using System.Drawing.Text;
using System.Collections;
using System.Web.UI.WebControls;
using System.Web.UI;
using System.Drawing.Drawing2D;
using System.Net.Mail;
using System.Net;
using System.Text.RegularExpressions;
using static QuanLyTaiSan_UserManagement.Common.CommonBMT;
using QRCoder;
using static System.Net.Mime.MediaTypeNames;
using QuanLyTaiSan_UserManagement.Common;
using QuanLyTaiSan_UserManagement.Helper;
using System.Text;

namespace QuanLyTaiSan_UserManagement.Controllers
{
    //[Authorize]
    public class DeviceController : BaseController
    {

        QuanLyTaiSanCtyEntities data = new QuanLyTaiSanCtyEntities();
        string Path_root = @"D:\UploadedFiles_QLTS";
        string Path_root_2 = @"D:\UploadedFiles_QLTS\";
        string Path_file = @"D:/UploadedFiles_QLTS/";


        [HasCredential(RoleID = "VIEW_DEVICE")]
        public ActionResult Device()
        {
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];

            int departmetnId = -1;

            if (session.GroupID == "DIRECTOR" || session.GroupID == "MANAGER")
            {
                departmetnId = Int32.Parse(data.UserLogins.Where(x => x.UserName == session.UserName).Select(x => x.Email).FirstOrDefault() ?? "0");

            }

            ViewData["TypeOfDevice"] = data.DeviceTypes.ToList();
            ViewData["ProjectDKC"] = data.GetUnitsById(departmetnId, session.UserName).ToList();
            ViewData["sProjectDKC"] = data.SearchProject(null, 1, 1, null).ToList();
            var lstDevice = data.SearchDevice(null, null, null, departmetnId, null, session.UserName)
                                .Where(x => x.Status != 2)
                                .OrderBy(x => x.CreatedDate)
                                .ThenBy(x => x.DeviceCode)
                                .ToList();
            ViewBag.CountDevice = data.SearchDevice(null, null, departmetnId, null, null, session.UserName).Where(x => x.Status != 2).Count();
            return View(lstDevice);
        }

        [HasCredential(RoleID = "SCAN_DEVICE")]
        public ActionResult ScanerDevice()
        {
            ViewData["TypeOfDevice"] = data.DeviceTypes.ToList();
            ViewData["ProjectDKC"] = data.ProjectDKCs.Where(x => x.Status != 3 & x.TypeProject == 1 & x.IsDeleted == false).ToList();
            ViewData["sProjectDKC"] = data.SearchProject(null, 1, 1, null).ToList();
            return View();
        }
        [HttpGet]
        [HasCredential(RoleID = "SCAN_DEVICE")]
        public JsonResult GetDeviceScaner(string DeviceCode)
        {
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];
            data.Configuration.ProxyCreationEnabled = false;
            bool Result = false;
            if (data.SearchDevice(null, null, null, null, null, session.UserName).Where(x => x.DeviceCode.Trim() == DeviceCode).Count() == 1)
            {
                ViewBag.Scaner = data.SearchDevice(null, null, null, null, null, session.UserName).Where(x => x.DeviceCode.Trim() == DeviceCode).First();
                Result = true;
            }
            else Result = false;
            var model = ViewBag.Scaner;
            var result = new { Result, model };
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        public ActionResult SearchDevice(FormCollection collection)
        {
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];
            int departmetnId = -1;
            if (session.GroupID == "DIRECTOR" || session.GroupID == "MANAGER")
            {
                departmetnId = Int32.Parse(data.UserLogins.Where(x => x.UserName == session.UserName).Select(x => x.Email).FirstOrDefault() ?? "0");
            }
            var d = data.DeviceTypes.ToList();
            ViewData["TypeOfDevice"] = data.DeviceTypes.ToList();
            ViewData["ProjectDKC"] = data.GetUnitsById(departmetnId, session.UserName).ToList();
            ViewData["sProjectDKC"] = data.SearchProject(null, 1, 1, null).ToList();
            int Status = Convert.ToInt32(collection["Status"]);
            int? TypeOfDevice = collection["TypeOfDevice"].Equals("0") ? (int?)null : Convert.ToInt32(collection["TypeOfDevice"]);
            int Guarantee = Convert.ToInt32(collection["Guarantee"]);
            string Project = collection["ProjectDKC"];
            if (!Project.Equals("0"))
            {
                departmetnId = int.Parse(Project); 
            }
            string DeviceCode = collection["DeviceCode"];
            var charts = data.SearchDevice(Status, TypeOfDevice, Guarantee, departmetnId, DeviceCode,session.UserName).Where(x => x.Status != 2).ToList().OrderBy(x => x.CreatedDate).OrderBy(x => x.DeviceCode);
            ViewBag.CountDevice = data.SearchDevice(Status, TypeOfDevice, Guarantee, departmetnId, DeviceCode.Trim(), session.UserName).Where(x => x.Status != 2).Count();
            ViewBag.status = Status;
            ViewBag.deviceCode = DeviceCode;
            ViewBag.type = TypeOfDevice;
            ViewBag.guarantee = Guarantee;
            ViewBag.poject = int.Parse(Project);
            var model = charts.ToList();
            return View("Device", model);
        }
        public ActionResult Deviceliquidation()
        {
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];
            ViewData["sProjectDKC"] = data.SearchProject(null, 1, null, null).ToList();
            ViewData["TypeOfDevice"] = data.DeviceTypes.ToList();
            ViewData["ProjectDKC"] = data.ProjectDKCs.Where(x => x.Status != 3 & x.IsDeleted == false).ToList();
            var lstDevice = data.SearchDevice(null, null, null, null, null,session.UserName).Where(x => x.Status == 2).ToList();
            return View(lstDevice);
        }
        [HasCredential(RoleID = "VIEW_DEVICE")]
        public ActionResult TypeDevice(int Id)
        {

            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];
            int? departmetnId = -1;

            if (session.GroupID == "DIRECTOR" || session.GroupID == "MANAGER")
            {
                departmetnId = Int32.Parse(data.UserLogins.Where(x => x.UserName == session.UserName).Select(x => x.Email).FirstOrDefault() ?? "0");
            }

            ViewBag.type = Id;
            ViewBag.Title = data.DeviceTypes.Where(x => x.Id == Id).SingleOrDefault().TypeName.ToString();
            ViewData["TypeOfDevice"] = data.DeviceTypes.Where(x => x.Id == Id).ToList();
            ViewData["ProjectDKC"] = data.GetUnitsById(departmetnId, session.UserName).ToList();
            ViewData["sProjectDKC"] = data.SearchProject(null, 1, 1, null).ToList();
            ViewBag.CountDevice = data.SearchDevice(null, Id, null, departmetnId, null,session.UserName).Where(x => x.Status != 2).Count();
            var lstDevice = data.SearchDevice(null, Id, null, departmetnId, null,session.UserName).Where(x => x.Status != 2).ToList();
            return View(lstDevice);
        }


        [HttpPost]
        public ActionResult SearchTypeDevice(FormCollection collection)
        {
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];
            int? departmetnId = -1;

            if (session.GroupID == "DIRECTOR" || session.GroupID == "MANAGER")
            {
                departmetnId = Int32.Parse(data.UserLogins.Where(x => x.UserName == session.UserName).Select(x => x.Email).FirstOrDefault() ?? "0");
            }
            var d = data.DeviceTypes.ToList();
            //  ViewData["TypeOfDevice"] = data.DeviceTypes.ToList();
            
            ViewData["sProjectDKC"] = data.SearchProject(null, 1, 1, null).ToList();
            int Status = Convert.ToInt32(collection["Status"]);
            int? TypeOfDevice = collection["TypeOfDevice"].Equals("0") ? (int?)null : Convert.ToInt32(collection["TypeOfDevice"]);
            int Guarantee = Convert.ToInt32(collection["Guarantee"]);
            string Project = collection["ProjectDKC"];
            if (!Project.Equals("0"))
            {
                departmetnId = int.Parse(Project); 
            }

            ViewData["ProjectDKC"] = data.GetUnitsById(departmetnId, session.UserName).ToList();

            string DeviceCode = collection["DeviceCode"];
            var charts = data.SearchDevice(Status, TypeOfDevice, Guarantee, departmetnId, DeviceCode.Trim(),session.UserName).Where(x => x.Status != 2).ToList();
            ViewBag.CountDevice = data.SearchDevice(Status, TypeOfDevice, Guarantee, departmetnId, DeviceCode.Trim(),session.UserName).Where(x => x.Status != 2).Count();
            ViewBag.status = Status;
            ViewBag.deviceCode = DeviceCode;
            ViewBag.type = TypeOfDevice;
            ViewBag.guarantee = Guarantee;
            ViewBag.poject = int.Parse(Project);
            ViewBag.Title = data.DeviceTypes.Where(x => x.Id == TypeOfDevice).SingleOrDefault().TypeName.ToString();
            ViewData["TypeOfDevice"] = data.DeviceTypes.Where(x => x.Id == TypeOfDevice).ToList();
            var model = charts.ToList();
            return View("TypeDevice", model);
        }

        //  [AuthorizationViewHandler]
        [HasCredential(RoleID = "ADD_DEVICE")]
        public ActionResult Create(int Id)
        {
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];
            int? departmetnId = -1;

            if (session.GroupID == "DIRECTOR" || session.GroupID == "MANAGER")
            {
                departmetnId = Int32.Parse(data.UserLogins.Where(x => x.UserName == session.UserName).Select(x => x.Email).FirstOrDefault() ?? "0");

            }

            ViewData["ProjectDKC"] = data.GetUnitsById(departmetnId, session.UserName).ToList();
           
            ViewBag.TypeDevice = Id;

            var listDevice = data.SearchDevice(null, null, null, departmetnId, null, session.UserName);

            ViewData["TypeOfDevice"] = data.DeviceTypes.ToList(); ;

            ViewData["User"] = data.Users.Where(x => x.IsDeleted == false & x.Status == 0).ToList();
            ViewData["Supplier"] = data.Suppliers.ToList();
            ViewData["Device"] = data.Devices.Where(x => x.IsDeleted == false).ToList();
            return View();
        }
        [HttpPost]
        [ValidateInput(false)]
        [HasCredential(RoleID = "ADD_DEVICE")]
        public ActionResult Create(FormCollection collection, IEnumerable<HttpPostedFileBase> files)
        {

            int DeviceId_1;
            try
            {
                var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];

                int departmetnId = -1;

                if (session.GroupID == "DIRECTOR" || session.GroupID == "MANAGER")
                {
                    departmetnId = Int32.Parse(data.UserLogins.Where(x => x.UserName == session.UserName).Select(x => x.Email).FirstOrDefault() ?? "0");
                }

                int? TypeOfDevice = collection["TypeOfDevice"].Equals("0") ? (int?)null : Convert.ToInt32(collection["TypeOfDevice"]);
                string DeviceCode = collection["DeviceCode"];
                string NewCode = collection["NewCode"];
                string DeviceName = collection["DeviceName"];
                double Price = collection["Price"].Equals("") ? 0 : Convert.ToDouble(collection["Price"].Replace(",",""));
                //Price = (Price1.ToString().Replace(",", "")); 
                string Configuration = collection["Configuration"];
                string Notes = collection["Notesdv"];
                int? SupplierId = collection["SupplierId"].Equals("0") ? (int?)null : Convert.ToInt32(collection["SupplierId"]);
                int? Status = Convert.ToInt32(collection["Status"]);
                int? Project = collection["UnitProjectDKC"].Equals("0") ? (int?)null : Convert.ToInt32(collection["UnitProjectDKC"]);
                string PurchaseContract = collection["PurchaseContract"];
                DateTime? DateOfPurchase = collection["DateOfPurchase"].Equals("") ? (DateTime?)null : Convert.ToDateTime(collection["DateOfPurchase"]);
                DateTime? Guarantee = collection["Guarantee"].Equals("") ? (DateTime?)null : Convert.ToDateTime(collection["Guarantee"]);
                int? UserId = collection["UserId"].Equals("0") ? (int?)null : Convert.ToInt32(collection["UserId"]);
                // int? ParentId = collection["ParentId"].Equals("0") ? (int?)null : Convert.ToInt32(collection["ParentId"]);
                string DeviceNameEnglish = collection["DeviceNameEnglish"];
                string DeviceModel = collection["DeviceModel"];
                string DeviceSeria = collection["DeviceSeria"];
                DateTime? DateAdded = collection["DateAdded"].Equals("") ? (DateTime?)null : Convert.ToDateTime(collection["DateAdded"]);

                data.AddDevice(DeviceCode, null, DeviceName, TypeOfDevice, null, Configuration, Price, PurchaseContract, DateOfPurchase, SupplierId, Project, Guarantee, Notes, UserId, Status, DeviceNameEnglish, DeviceModel, DeviceSeria, DateAdded);
                var DeviceId = data.Devices.Where(x => x.DeviceCode == DeviceCode).Single().Id;
                DeviceId_1 = Convert.ToInt32(DeviceId);
                // INSERT FILE
                Insert_file(files, DeviceCode, DeviceId_1);


            }
            catch
            {
                AlertMessage("Đã xảy ra lỗi !");
                return null;
            }
            return RedirectToAction("EditDevice", "Device", new { Id = DeviceId_1 });
        }

        public void Insert_file(IEnumerable<HttpPostedFileBase> files, string DeviceCode, int DeviceId_1)
        {
            //BMT
            string Path_device_folder = Path_root_2 + DeviceCode;  // Thư mục thiết bị
            string Path_device_file = Path_file + DeviceCode + "/";  // đường dẫn ảnh thiết bị
            foreach (var file in files)
            {
                if (file != null)
                {
                    // Check tồn tại thư mục cha
                    if (!Directory.Exists(Path_root))
                    {
                        Directory.CreateDirectory(Path_root);
                    }
                    // Check tồn tại thư mục con
                    if (!Directory.Exists(Path_device_folder))
                    {
                        Directory.CreateDirectory(Path_device_folder);
                    }
                    var InputFileName = Path.GetFileName(file.FileName);
                    // var ServerSavePath = Path.Combine(Server.MapPath("~/UploadedFiles/") + InputFileName);
                    var ServerSavePath = Path.Combine(Path_device_file + InputFileName);
                    file.SaveAs(ServerSavePath);

                    // Lưu database
                    data.AddDeviceFiles(DeviceId_1, DeviceCode, file.FileName, "", "", file.ContentType, ServerSavePath);
                }
            }
            //BMT
        }


        // Dowload File
        public FileResult dowload_file(string id_file)
        {
            try
            {
                // string path = Server.MapPath("~/UploadedFiles/") + "qrcode_localhost.png";
                int _id = Convert.ToInt32(id_file);
                var _file = data.DeviceFiles.Where(x => x.id == _id).FirstOrDefault();
                byte[] bytes = System.IO.File.ReadAllBytes(_file.FileLocal);
                return File(bytes, "application/octet-stream", _file.FileNames);
            }
            catch (Exception ex)
            {
                logs("ERRO", "DeviceController", "dowload_file", ex.Message);
                AlertMessage("Có lỗi xảy ra vui lòng thử lại ! err: " + ex.Message);
                return null;
            }

        }


        // Check loại file nào được xem 
        [HttpGet]
        public JsonResult check_file(string file_id)
        {
            bool result;
            int _id = Convert.ToInt32(file_id);
            var _file = data.DeviceFiles.Where(x => x.id == _id).FirstOrDefault();
            if (_file.FileType == "image/png" || _file.FileType == "image/jpeg" || _file.FileType == "image/gif" || _file.FileType == "application/pdf" || _file.FileType == "text/plain")
            {
                result = true;
            }
            else
            {
                result = false;
            }


            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public FileStreamResult OpenFile(string id_file)
        {
            try
            {
                int _id = Convert.ToInt32(id_file);
                var _file = data.DeviceFiles.Where(x => x.id == _id).FirstOrDefault();
                var pathToTheFile = Path.Combine(_file.FileLocal);
                var fileStream = new FileStream(pathToTheFile,
                                                 FileMode.Open,
                                                 FileAccess.Read
                                             );
                return new FileStreamResult(fileStream, _file.FileType);
            }
            catch
            {
                AlertMessage("Đã có lỗi xảy ra. Vui lòng thử lại !");
                return null;
            }
        }


        [HttpGet]
        public JsonResult delete_file(string id_file)
        {
            bool result;
            try
            {
                int _id = Convert.ToInt32(id_file);
                var _file = data.DeviceFiles.Where(x => x.id == _id).FirstOrDefault();
                // Xóa trong DB
                data.DeleteDeviceFiles(_id, null);
                if (System.IO.File.Exists(Path.Combine(_file.FileLocal)))
                {
                    System.IO.File.Delete(Path.Combine(_file.FileLocal));
                }

                result = true;
            }
            catch (Exception ex)
            {
                logs("ERRO", "DeviceController", "delete_file", ex.Message);
                result = false;
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        // Xóa thư mục file thiết bi + xóa db file thiết bị
        public void delete_folderDevice(int id_device)
        {
            int _id = Convert.ToInt32(id_device);
            var DeviceCode = data.DeviceById(_id).Select(x => x.DeviceCode).FirstOrDefault();
            string Path_device_folder = Path_file + DeviceCode.Trim();  // Thư mục thiết bị
            if (Directory.Exists(Path_device_folder))
            {
                Directory.Delete(Path_device_folder, true);
                // Xóa trong DB
                data.DeleteDeviceFiles(null, DeviceCode);
            }
        }
        //kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk


        [HasCredential(RoleID = "EDIT_DEVICE")]
        public ActionResult EditDevice(int Id)
        {
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];
            int? departmetnId = -1;

            if (session.GroupID == "DIRECTOR" || session.GroupID == "MANAGER")
            {
                departmetnId = Int32.Parse(data.UserLogins.Where(x => x.UserName == session.UserName).Select(x => x.Email).FirstOrDefault() ?? "0");
            }

            ViewBag.CheckDv = data.DeviceOfProjects.Where(x => x.DeviceId == Id).Count();
            ViewBag.CheckDvDv = data.DeviceDevices.Where(x => x.DeviceCodeChildren == Id || x.DeviceCodeParents == Id).Count();

            // ViewData EditDevice
            var DvType = data.DeviceById(Id).Select(x => x.TypeOfDevice).SingleOrDefault();
            int a = Convert.ToInt32(DvType);
            ViewData["TypeOfProject"] = data.DeviceOfProjects.Where(x => x.DeviceId == Id);
            ViewData["TypeOfDevice"] = data.DeviceTypes.ToList();
            ViewData["User"] = data.Users.Where(x => x.IsDeleted == false & x.Status == 0).ToList();
            ViewData["Supplier"] = data.Suppliers.ToList();
            ViewData["Device"] = data.Devices.Where(x => x.IsDeleted == false).ToList();
            ViewData["ProjectDKC"] = data.GetUnitsById(departmetnId, session.UserName).ToList();
            ViewData["sProjectDKC"] = data.SearchProject(null, 1, 1, null).ToList();
            ViewData["RepairDetail"] = data.SearchRepairDetails(null, null, Id, null, departmetnId).OrderByDescending(x => x.DateOfRepair).ToList();
            ViewData["DeviceHistory"] = data.DeviceHistory().Where(x => x.DeviceId == Id).ToList();
            ViewData["UsageDevice"] = data.SearchUseDevice(Id).ToList();
            ViewData["SearchDeviceComponant"] = data.SearchDevice(null, null, null, null, null, session.UserName).ToList();
            ViewData["DeviceFile"] = data.DeviceFiles.Where(x => x.DeviceId == Id).ToList();
            ViewData["DeviceFile_Pic"] = data.DeviceFiles.Where(x => x.DeviceId == Id && (x.FileType == "image/png" || x.FileType == "image/jpeg" || x.FileType == "image/gif")).ToList();
            List<DeviceFile> lst_file = new List<DeviceFile>();

            foreach (var item in ViewData["DeviceFile_Pic"] as IList<DeviceFile>)
            {
                try
                {
                    byte[] bytes = System.IO.File.ReadAllBytes(item.FileLocal);
                    lst_file.Add(new DeviceFile() { FileLocal = "data:image/png;base64," + Convert.ToBase64String(bytes) });
                }

                catch (Exception ex)
                {
                    logs("ERRO", "DeviceController", "EditDevice", ex.Message);
                    AlertMessage("Có lỗi xảy ra. File thiết bị không tìm thấy !");

                }

            }

            ViewData["DeviceFile_Pic_2"] = lst_file;

            List<ChildrenOfDevice_Result> numbers = new List<ChildrenOfDevice_Result>();
            var lstTypeDevice = data.TypeComponantOfDevice(a).Where(x => x.IsDeleted == false).ToList();

            foreach (var item in lstTypeDevice)
            {
                var lstTag = data.ChildrenOfDevice(Id, item.TypeSymbolChildren).ToList();
                Array a2 = lstTag.ToArray();
                numbers.Add(new ChildrenOfDevice_Result { TypeName = item.NameTypeChildren, TypeSymbolChildren = item.TypeSymbolChildren});
            }
            ViewData["TypeComponantOfDevice"] = numbers;
            //    public Array numbers { get; set; }   

            // Danh sách thiết bị con theo loại của thiết bị cha 
            var chart = data.DeviceById(Id).Single();
            int? user_id = chart.UserId;
            ViewData["UserUseDevice"] = data.Users.Where(x => x.Id == user_id).Select(x => x.UserName).FirstOrDefault();
            return View(chart);
        }
        [HttpPost]
        [ValidateInput(false)]
        [HasCredential(RoleID = "EDIT_DEVICE")]
        public ActionResult EditDevice(FormCollection collection, IEnumerable<HttpPostedFileBase> files)
        {

            int? TypeOfDevice = 0;
            var check = collection["TypeOfDevice"];
            int DeviceId = Convert.ToInt32(collection["hiddenIddv"]);
            if (check_file_exists(files, DeviceId))
            {
                try
                {
                    if (check == null)
                    {
                        TypeOfDevice = Convert.ToInt32(collection["hiddenTypeId"]);
                    }
                    else
                    {
                        TypeOfDevice = collection["TypeOfDevice"].Equals("0") ? (int?)null : Convert.ToInt32(collection["TypeOfDevice"]);

                    }
                    var b = collection["hiddenParentID"];
                    var a = Convert.ToInt32(collection["UserId"]);
                    //int? TypeOfDevice = collection["TypeOfDevice"].Equals("0") ? (int?)null : Convert.ToInt32(collection["TypeOfDevice"]);
                    string DeviceCode = collection["DeviceCode"];
                    string NewCode = collection["NewCode"];
                    string DeviceName = collection["DeviceName"];
                    double Price = collection["Price"].Equals("") ? 0 : Convert.ToDouble(collection["Price"].Replace(",",""));
                    string Configuration = collection["Configuration"];
                    int? SupplierId = collection["SupplierId"].Equals("0") ? (int?)null : Convert.ToInt32(collection["SupplierId"]);
                    string PurchaseContract = collection["PurchaseContract"];
                    string Notes = collection["Notesdv"];
                    DateTime? DateOfPurchase = collection["DateOfPurchase"].Equals("") ? (DateTime?)null : Convert.ToDateTime(collection["DateOfPurchase"]);
                    DateTime? Guarantee = collection["Guarantee"].Equals("") ? (DateTime?)null : Convert.ToDateTime(collection["Guarantee"]);
                    int? UserId = collection["UserId"].Equals("0") ? (int?)null : Convert.ToInt32(collection["UserId"]);
                    int? ParentId = collection["hiddenParentID"].Equals("") ? (int?)null : Convert.ToInt32(collection["hiddenParentID"]);
                    int Status = Convert.ToInt32(collection["Status"]);
                    DateTime? CreatedDate = collection["CreatedDate"].Equals("") ? (DateTime?)null : Convert.ToDateTime(collection["CreatedDate"]);
                    string DeviceNameEnglish = collection["DeviceNameEnglish"];
                    string DeviceModel = collection["DeviceModel"];
                    string DeviceSeria = collection["DeviceSeria"];
                    DateTime? DateAdded = collection["DateAdded"].Equals("") ? (DateTime?)null : Convert.ToDateTime(collection["DateAdded"]);

                    data.UpdateDevice(DeviceId, DeviceCode, null, DeviceName, TypeOfDevice, ParentId, Configuration, Price, PurchaseContract, DateOfPurchase, SupplierId, Guarantee, UserId, Notes, CreatedDate, Status, DeviceNameEnglish, DeviceModel, DeviceSeria, DateAdded);


                    var lstComponant = data.DeviceDevices.Where(x => x.DeviceCodeParents == DeviceId & x.IsDeleted == false & x.TypeComponant == 1).Select(x => x.DeviceCodeChildren).ToList();
                    foreach (var item in lstComponant)
                    {
                        // update người dùng của thiết bị con khi thiết bị cha thay đổi ng dùng
                        data.UpdateUserDevice(item.Value, UserId);
                    }
                    // INSERT FILE
                    Insert_file(files, DeviceCode, DeviceId);
                }
                catch (Exception ex)
                {
                    logs("ERRO", "DeviceController", "EditDevice", ex.Message);
                    TempData["ERR"] = "Co loi xay ra. Vui long thu lai !";
                }
            }
            else
            {
            }
            return RedirectToAction("EditDevice", "Device", DeviceId);

        }
        // Check file của thiết bị đã tồn tại
        public bool check_file_exists(IEnumerable<HttpPostedFileBase> files, int Device_id)
        {
            foreach (var file in files)
            {
                if (file != null)
                {
                    int check = data.DeviceFiles.Where(x => x.DeviceId == Device_id && x.FileNames == file.FileName).Count();
                    if (check > 0)
                    {
                        TempData["ERR"] = @"File " + file.FileName + " da ton tai. Xoa file cu truoc khi tai len !";
                        return false;
                    }
                }

            }
            return true;
        }
        [HasCredential(RoleID = "RETURN_DEVICETODEPOT")]
        public ActionResult ReturnDeviceInProject(int Idpr, int Iddv)
        {
            bool result = true;
            var check = 0;
            check += data.DeviceDevices.Where(x => x.DeviceCodeChildren == Iddv & x.IsDeleted == false & x.TypeComponant == 1).Count();
            if (check > 0)
            {
                result = false;
            }
            else
            {
                var lstComponant = data.DeviceDevices.Where(x => x.DeviceCodeParents == Iddv & x.IsDeleted == false & x.TypeComponant == 1).Select(x => x.DeviceCodeChildren).ToList();
                foreach (var item in lstComponant)
                {
                    // Trả thiết bị con về kho
                    data.ReturnDeviceProject(Convert.ToInt32(item));
                }

                int checkdele = data.ReturnDeviceOfProject(Idpr, Iddv, "");
                if (checkdele > 0)
                    result = true;
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        [HasCredential(RoleID = "RETURN_DEVICETODEPOT")]
        public JsonResult ReturnDeviceProject(string Id)
        {

            bool result = true;
            var lstId = Id.Split(',');
            var check = 0;
            for (int i = 0; i < lstId.Length; i++)
            {
                var IdP = Convert.ToInt32(lstId[i]);
                //Check thiết bị xem có phải là thiết bị con nằm trong
                check += data.DeviceDevices.Where(x => x.DeviceCodeChildren == IdP & x.IsDeleted == false & x.TypeComponant == 1).Count();
            }
            if (check > 0)
            {
                result = false;
            }
            else
            {
                // Lấy danh sách thiết bị con từ danh sách thiết bị cha
                for (int i = 0; i < lstId.Length; i++)
                {
                    var IdP = Convert.ToInt32(lstId[i]);
                    var lstComponant = data.DeviceDevices.Where(x => x.DeviceCodeParents == IdP & x.IsDeleted == false & x.TypeComponant == 1).Select(x => x.DeviceCodeChildren).ToList();
                    foreach (var item in lstComponant)
                    {
                        // Trả thiết bị con về kho
                        data.ReturnDeviceProject(Convert.ToInt32(item));
                    }
                }


                // Trả thiết bị về kho 
                for (int i = 0; i < lstId.Length; i++)
                {
                    if (!lstId[i].Equals(""))
                        data.ReturnDeviceProject(Convert.ToInt32(lstId[i]));
                }
                result = true;
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        [ValidateInput(false)]
        [HasCredential(RoleID = "ADD_SUPPLIER")]
        public JsonResult AddSupplier(string Name, string Email, string PhoneNumber, string Address, string Support)
        {
            data.AddSupplier(Name, Email, PhoneNumber, Address, Support);
            bool result = true;
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        [ValidateInput(false)]
        [HasCredential(RoleID = "ADD_EMPLOYEE")]
        public JsonResult AddEmployees(string UserName, string FullName, string Email, string PhoneNumber, string Address, string Department, string Position)
        {
            data.AddUser(UserName, null, FullName, Email, PhoneNumber, Address, Department, Position, null, 0);
            bool result = true;
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        [ValidateInput(false)]
        [HasCredential(RoleID = "ADD_REPAIR_DEVICE")]
        public JsonResult AddRepairDevice(int Iddv, int user, string Notesrepair)
        {
            if (user == 0)
            {
                data.AddRepairDetails(Iddv, DateTime.Now, null, null, null, null, null, Notesrepair);
            }
            else { data.AddRepairDetails(Iddv, DateTime.Now, null, null, null, null, user, Notesrepair); }
            bool result = true;
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        [ValidateInput(false)]
        [HasCredential(RoleID = "ADD_REPAIR_DEVICE")]
        public JsonResult AddDeviceType(string TypeName, string TypeSymbol, string Notes)
        {
            bool result = false;
            var listdvt = data.DeviceTypes.Where(x => x.TypeSymbol.Trim() == TypeSymbol.Trim()).ToList();
            if (listdvt.Count() > 0) { result = false; }
            else
            {
                data.AddDeviceType(TypeName, TypeSymbol, Notes);
                result = true;
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        [HasCredential(RoleID = "ADD_DEVICEINPROJECT")]
        public JsonResult AddDeviceProject1(string Id, int PJ)
        {
            bool result = true;
            var IdParent = Id.Split(',');
            var check = 0;
            for (int i = 0; i < IdParent.Length; i++)
            {
                var IdP = Convert.ToInt32(IdParent[i]);
                //Check thiết bị xem có phải là thiết bị con nằm trong
                check += data.DeviceDevices.Where(x => x.DeviceCodeChildren == IdP & x.IsDeleted == false & x.TypeComponant == 1).Count();
            }
            if (check > 0)
            {
                result = false;
            }
            else
            {
                // Lấy danh sách thiết bị con từ danh sách thiết bị cha
                for (int i = 0; i < IdParent.Length; i++)
                {
                    var IdP = Convert.ToInt32(IdParent[i]);
                    var lstComponant = data.DeviceDevices.Where(x => x.DeviceCodeParents == IdP & x.IsDeleted == false & x.TypeComponant == 1).Select(x => x.DeviceCodeChildren).ToList();
                    foreach (var item in lstComponant)
                    {
                        // Thêm thiết bị con vào DeviceOfProject
                        data.AddDeviceOfProject(PJ, Convert.ToInt32(item), "");
                    }
                }
                //Thêm thiết bị cha vào DeviceOfProject
                var lstId = Id.Split(',');
                for (int i = 0; i < lstId.Length; i++)
                {
                    if (!lstId[i].Equals(""))
                        data.AddDeviceOfProject(PJ, Convert.ToInt32(lstId[i]), "");
                }
                result = true;
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        [HttpGet]
        public JsonResult Searchdv(int TypeOfDevice, int Status, int Guarantee, int Project, string DeviceCode)
        {
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];
            data.Configuration.ProxyCreationEnabled = false;
            var charts = data.SearchDevice(Status, TypeOfDevice, Guarantee, Project, DeviceCode,session.UserName).ToList();
            var model = charts.ToList();
            return Json(new
            {
                data = model,
            }, JsonRequestBehavior.AllowGet);
        }
        [HttpGet]
        public JsonResult AddDeviceCode(int TypeOfDevice)
        {
            data.Configuration.ProxyCreationEnabled = false;
            var type = data.OderCode(TypeOfDevice).Single().Code;
            var TypeSymbol = data.DeviceTypes.Where(x => x.Id == TypeOfDevice).Single().TypeSymbol.Trim() + type.ToString().PadLeft(5, '0');
            var charts = data.Devices.Where(x => x.DeviceCode == TypeSymbol).FirstOrDefault();
            if (charts == null)
            {
            }
            else
            {
                type = data.OderCode(TypeOfDevice).Single().Code;
                TypeSymbol = data.DeviceTypes.Where(x => x.Id == TypeOfDevice).Single().TypeSymbol.Trim() + type.ToString().PadLeft(5, '0');
            }
            return Json(new
            {
                data = TypeSymbol,
            }, JsonRequestBehavior.AllowGet);
        }
        [HasCredential(RoleID = "ADD_DEVICEINPROJECT")]
        public JsonResult AddDeviceProject(int Iddv, int Idpj)
        {
            bool result = true;
            var Check = data.DeviceDevices.Where(x => x.DeviceCodeChildren == Iddv & x.IsDeleted == false & x.TypeComponant == 1).Select(x => x.DeviceCodeChildren).Count();
            if (Check > 0)
            {
                result = false;
            }
            else
            {
                var lstComponant = data.DeviceDevices.Where(x => x.DeviceCodeParents == Iddv & x.IsDeleted == false & x.TypeComponant == 1).Select(x => x.DeviceCodeChildren).ToList();
                foreach (var item in lstComponant)
                {
                    data.AddDeviceOfProject(Idpj, item.Value, "");
                }
                int checkdele = data.AddDeviceOfProject(Idpj, Iddv, "");
                result = true;
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [HasCredential(RoleID = "LIQUIDATION_DEVICE")]
        public JsonResult LiquidationDevice(string Id)
        {
            bool result = true;
            var check = 0;
            var IdParent = Id.Split(',');
            for (int i = 0; i < IdParent.Length; i++)
            {
                // Kiểm tra có tồn tại thiết bị con nằm trong thiết bị cha
                var IdCom = Convert.ToInt32(IdParent[i]);
                check += data.DeviceDevices.Where(x => x.DeviceCodeChildren == IdCom & x.IsDeleted == false & x.TypeComponant == 1).Select(x => x.DeviceCodeChildren).Count();
            }
            if (check > 0)
            {
                result = false;
            }
            else
            {
                // Lấy danh sách thiết bị con trong  từ danh sách thiết bị cha
                for (int i = 0; i < IdParent.Length; i++)
                {
                    var IdP = Convert.ToInt32(IdParent[i]);
                    var lstComponant = data.DeviceDevices.Where(x => x.DeviceCodeParents == IdP & x.IsDeleted == false & x.TypeComponant == 1).Select(x => x.DeviceCodeChildren).ToList();
                    foreach (var item in lstComponant)
                    {
                        string v = "," + item + ",";
                        // Thanh lý thiết bị con trong theo thiết bị cha
                        data.LiquidationDevice(v);
                    }
                    //Khi thanh lý TB cha thì  Gỡ thiết bị con ngoài khỏi thiết bị cha
                    var lstComponant_out = data.DeviceDevices.Where(x => x.DeviceCodeParents == IdP & x.IsDeleted == false & x.TypeComponant == 0).Select(x => x.DeviceCodeChildren).ToList();
                    {
                        foreach (var item in lstComponant_out)
                        {
                            data.DeleteDeviceOfDevice(IdP, item, "Thiết bị cha bị thanh lý");
                        }
                    }
                    // KHi thanh lý tb con ở ngoài thì xóa mối quan hệ cha con của thiết bị vs cha còn hoạt động
                    var lstParent = data.DeviceDevices.Where(x => x.DeviceCodeChildren == IdP & x.IsDeleted == false & x.TypeComponant == 0).Select(x => x.DeviceCodeParents).ToList();
                    {
                        foreach (var item in lstParent)
                        {
                            data.DeleteDeviceOfDevice(item, IdP, "Thiết bị con bị thanh lý");
                        }
                    }
                }
                // Thanh lý thiết bị cha
                string a = "," + Id + ",";
                int checkdele = data.LiquidationDevice(a);
                if (checkdele > 0)
                    result = true;
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        [HasCredential(RoleID = "DELETE_DEVICE")]
        public JsonResult DeleteDevice(string Id)
        {
            bool result = true;
            var check = 0;
            var IdParent = Id.Split(',');
            for (int i = 0; i < IdParent.Length; i++)
            {
                // Kiểm tra có tồn tại thiết bị con nằm trong thiết bị cha
                var IdCom = Convert.ToInt32(IdParent[i]);
                check += data.DeviceDevices.Where(x => x.DeviceCodeChildren == IdCom & x.IsDeleted == false & x.TypeComponant == 1).Select(x => x.DeviceCodeChildren).Count();
            }
            if (check > 0)
            {
                result = false;
            }
            else
            {
                // Lấy danh sách thiết bị con từ danh sách thiết bị cha
                for (int i = 0; i < IdParent.Length; i++)
                {
                    var IdP = Convert.ToInt32(IdParent[i]);
                    var lstComponant = data.DeviceDevices.Where(x => x.DeviceCodeParents == IdP & x.IsDeleted == false & x.TypeComponant == 1).Select(x => x.DeviceCodeChildren).ToList();
                    foreach (var item in lstComponant)
                    {
                        string v = "," + item + ",";
                        // Thanh lý thiết bị con theo thiết bị cha
                        data.DeleteDevice1(v);
                        int _id = Convert.ToInt32(item);
                        delete_folderDevice(_id);
                    }
                    //Khi xóa TB cha thì  Gỡ thiết bị con ngoài khỏi thiết bị cha
                    var lstComponant_out = data.DeviceDevices.Where(x => x.DeviceCodeParents == IdP & x.IsDeleted == false & x.TypeComponant == 0).Select(x => x.DeviceCodeChildren).ToList();
                    {
                        foreach (var item in lstComponant_out)
                        {
                            data.DeleteDeviceOfDevice(IdP, item, "Thiết bị cha bị xóa");
                        }
                    }
                    // KHi xóa tb con ở ngoài thì xóa mối quan hệ cha con của thiết bị cha còn hoạt động
                    var lstParent = data.DeviceDevices.Where(x => x.DeviceCodeChildren == IdP & x.IsDeleted == false & x.TypeComponant == 0).Select(x => x.DeviceCodeParents).ToList();
                    {
                        foreach (var item in lstParent)
                        {
                            data.DeleteDeviceOfDevice(item, IdP, "Thiết bị con bị xóa");
                        }
                    }
                }
                string a = "," + Id + ",";
                int checkdele = data.DeleteDevice1(a);
                if (checkdele > 0)
                    result = true;
                // Xóa thư mục file của thiết bị
                for (int i = 0; i < IdParent.Length; i++)
                {
                    int _id = Convert.ToInt32(IdParent[i]);
                    delete_folderDevice(_id);
                }
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        [HasCredential(RoleID = "PRINTBARCODE_DEVICE")]
        public JsonResult GenerateBarCode(string barcode)
        {
            string src = "";

            string code = barcode.ToString();
            QRCodeGenerator qrGenerator = new QRCodeGenerator();
            QRCodeData qrCodeData = qrGenerator.CreateQrCode(code, QRCodeGenerator.ECCLevel.Q);
            System.Web.UI.WebControls.Image imgBarCode = new System.Web.UI.WebControls.Image();
            imgBarCode.Height = 150;
            imgBarCode.Width = 150;
            QRCode qrCode = new QRCode(qrCodeData);
            using (Bitmap bitMap = qrCode.GetGraphic(3))
            {
                using (MemoryStream ms = new MemoryStream())
                {
                    bitMap.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
                    byte[] byteImage = ms.ToArray();
                    Convert.ToBase64String(byteImage);
                    imgBarCode.ImageUrl = "data:image/png;base64," + Convert.ToBase64String(byteImage);
                    src = imgBarCode.ImageUrl;
                }

            }
            return Json(new
            {
                data = src,
            }, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        [HasCredential(RoleID = "PRINTBARCODE_DEVICE")]
        public JsonResult GenerateBarCodeDevice(string dvcode, string dvid)
        {
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];
            ArrayList idList = new ArrayList();
            var a = dvid.Split(',');
            for (int i = 0; i < a.Length; i++)
            {
                if (!a[i].Equals(""))
                    idList.Add(Convert.ToInt32(a[i]));
            }
            var Listdv = data.SearchDevice(null, null, null, null, null,session.UserName).Where(t => idList.Contains(t.Id)).ToList();
            ArrayList list = new ArrayList();
            var lstdv = dvcode.Split(',');
            for (int i = 0; i < lstdv.Length; i++)
            {
                string code = lstdv[i].ToString();
                QRCodeGenerator qrGenerator = new QRCodeGenerator();
                QRCodeData qrCodeData = qrGenerator.CreateQrCode(code, QRCodeGenerator.ECCLevel.Q);
                System.Web.UI.WebControls.Image imgBarCode = new System.Web.UI.WebControls.Image();
                imgBarCode.Height = 150;
                imgBarCode.Width = 150;
                QRCode qrCode = new QRCode(qrCodeData);
                using (Bitmap bitMap = qrCode.GetGraphic(3))
                {
                    using (MemoryStream ms = new MemoryStream())
                    {
                        bitMap.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
                        byte[] byteImage = ms.ToArray();
                        Convert.ToBase64String(byteImage);
                        imgBarCode.ImageUrl = "data:image/png;base64," + Convert.ToBase64String(byteImage);
                    }

                }
                list.Add(imgBarCode.ImageUrl);

            }
            var result = new { list, Listdv };
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        //[HttpPost]
        //public ActionResult UploadFiles(HttpPostedFileBase[] files)
        //{

        //    //Ensure model state is valid  
        //    if (ModelState.IsValid)
        //    {   //iterating through multiple file collection   
        //        foreach (HttpPostedFileBase file in files)
        //        {
        //            //Checking file is available to save.  
        //            if (file != null)
        //            {
        //                var InputFileName = Path.GetFileName(file.FileName);
        //                var ServerSavePath = Path.Combine(Server.MapPath("~/UploadedFiles/") + InputFileName);
        //                //Save file to server folder  
        //                file.SaveAs(ServerSavePath);
        //                //assigning file uploaded status to ViewBag for showing message to user.  
        //                ViewBag.UploadStatus = files.Count().ToString() + " files uploaded successfully.";
        //            }

        //        }
        //    }
        //    return View();
        //}

        public static string HtmlToPlainText(string html)
        {
            const string tagWhiteSpace = @"(>|$)(\W|\n|\r)+<";//matches one or more (white space or line breaks) between '>' and '<'
            const string stripFormatting = @"<[^>]*(>|$)";//match any character between '<' and '>', even when end tag is missing
            const string lineBreak = @"<(br|BR)\s{0,1}\/{0,1}>";//matches: <br>,<br/>,<br />,<BR>,<BR/>,<BR />
            var lineBreakRegex = new Regex(lineBreak, RegexOptions.Multiline);
            var stripFormattingRegex = new Regex(stripFormatting, RegexOptions.Multiline);
            var tagWhiteSpaceRegex = new Regex(tagWhiteSpace, RegexOptions.Multiline);
            var text = html;
            //Decode html specific characters
            text = System.Net.WebUtility.HtmlDecode(text);
            //Remove tag whitespace/line breaks
            text = tagWhiteSpaceRegex.Replace(text, "><");
            //Replace <br /> with line breaks
            text = lineBreakRegex.Replace(text, Environment.NewLine);
            //Strip formatting
            text = stripFormattingRegex.Replace(text, string.Empty);
            return text;
        }

        public class NewConfig
        {
            // Auto-Initialized properties  
            public string DeviceCode { get; set; }
            public string DeviceName { get; set; }
            public string TypeName { get; set; }
            public string Configuration { get; set; }
            public string PriceOne { get; set; }
            public string Notes { get; set; }
            public string FullName { get; set; }
            public string Name { get; set; }
            public string ProjectSymbol { get; set; }
            public string Status { get; set; }
            public string DateAdd { get; set; }
        }
        public string GetStrStatus(string stt)
        {
            string _result = "";
            if (string.IsNullOrEmpty(stt) || stt == "0")
            { }
            else
            {
                _result = ", " + (Convert.ToInt32(stt)).GetEnumDescription(typeof(eStatus.RepairStatus)).ToString();
            }
            return _result;
        }

        [HasCredential(RoleID = "EXEL_LIST_DDEVICE")]
        [HttpPost]
        public JsonResult ExportToExcel(int? TypeOfDevice, int Status, int Guarantee, int? Project, string DeviceCode)
        {
            data.Configuration.ProxyCreationEnabled = false;
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];
            if (Project == 0) {
                  Project = -1;

                if (session.GroupID == "DIRECTOR" || session.GroupID == "MANAGER")
                {
                    Project = Int32.Parse(data.UserLogins.Where(x => x.UserName == session.UserName).Select(x => x.Email).FirstOrDefault() ?? "0");
                }
            }
            if (TypeOfDevice == 0) { 
                TypeOfDevice = null; 
            }
            var charts = data.SearchDevice(Status, TypeOfDevice, Guarantee, Project, DeviceCode, session.UserName).Select(i => new { i.DeviceCode, i.DeviceName, i.TypeName, i.Configuration, i.PriceOne, i.FullName, i.Name, i.ProjectSymbol, i.Status, i.StatusRepair, i.DateAdded }).Where(x => x.Status != 2).ToList();
            var model = charts.ToList();


            List<NewConfig> numbers = new List<NewConfig>();
            for (int i = 0; i < model.Count; ++i)
            {
                var a = HtmlToPlainText(model[i].Configuration);
                var _Status = (Convert.ToInt32(model[i].Status)).GetEnumDescription(typeof(eStatus.DeviceStatus)).ToString() + GetStrStatus(model[i].StatusRepair.ToString());
                var _DateAdd = @String.Format("{0:dd/MM/yyyy}", model[i].DateAdded);
                numbers.Add(new NewConfig { 
                    DeviceCode = model[i].DeviceCode, 
                    DeviceName = model[i].DeviceName,
                    TypeName = model[i].TypeName, 
                    Configuration = a, 
                    PriceOne = model[i].PriceOne,
                    FullName = model[i].FullName,
                    Name = model[i].Name,
                    ProjectSymbol = model[i].ProjectSymbol,
                    Status = _Status, 
                    DateAdd = _DateAdd }
                );
            }

            string strDateFormatDate = string.Format("{0:yyyy-MMM-dd-hh-mm-ss}", DateTime.Now);
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
                    strDateFormat = strDateFormatDate;
                    Response.AddHeader("content-disposition", "attachment; filename=UserDetails_" + strDateFormat + ".xls");
                    Response.ContentType = "application/vnd.ms-excel";
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


        [HasCredential(RoleID = "EXEL_LIST_DDEVICE")]
        [HttpPost]
        public JsonResult ExportToExcelCustom(int? TypeOfDevice, int Status, int Guarantee, int? Project, string DeviceCode)
        {
            data.Configuration.ProxyCreationEnabled = false;
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];
            if (Project == 0)
            {
                Project = -1;

                if (session.GroupID == "DIRECTOR" || session.GroupID == "MANAGER")
                {
                    Project = Int32.Parse(data.UserLogins.Where(x => x.UserName == session.UserName).Select(x => x.Email).FirstOrDefault() ?? "0");
                }
            }
            if (TypeOfDevice == 0)
            {
                TypeOfDevice = null;
            }
            var charts = data.SearchDevice(Status, TypeOfDevice, Guarantee, Project, DeviceCode, session.UserName).Select(i => new { i.DeviceCode, i.DeviceName, i.TypeName, i.Configuration, i.PriceOne, i.FullName, i.Name, i.ProjectSymbol, i.Status, i.StatusRepair, i.DateAdded }).Where(x => x.Status != 2).ToList();
            var model = charts.ToList();


            List<NewConfig> numbers = new List<NewConfig>();
            for (int i = 0; i < model.Count; ++i)
            {
                var a = HtmlToPlainText(model[i].Configuration);
                var _Status = (Convert.ToInt32(model[i].Status)).GetEnumDescription(typeof(eStatus.DeviceStatus)).ToString() + GetStrStatus(model[i].StatusRepair.ToString());
                var _DateAdd = @String.Format("{0:dd/MM/yyyy}", model[i].DateAdded);
                numbers.Add(new NewConfig
                {
                    DeviceCode = model[i].DeviceCode,
                    DeviceName = model[i].DeviceName,
                    TypeName = model[i].TypeName,
                    Configuration = a,
                    PriceOne = model[i].PriceOne,
                    FullName = model[i].FullName,
                    Name = model[i].Name,
                    ProjectSymbol = model[i].ProjectSymbol,
                    Status = _Status,
                    DateAdd = _DateAdd
                }
                );
            }

            string strDateFormatDate = string.Format("{0:yyyy-MMM-dd-hh-mm-ss}", DateTime.Now);
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
                    strDateFormat = strDateFormatDate;
                    Response.AddHeader("content-disposition", "attachment; filename=UserDetails_" + strDateFormat + ".xls");
                    Response.ContentType = "application/vnd.ms-excel";
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

        public ActionResult DownloadFile(string fileName)
        {
            string filePath = Path.Combine(Server.MapPath("~/App_Data"), fileName);

            return File(filePath, "application/vnd.ms-excel", fileName);
        }


        [HasCredential(RoleID = "VIEW_STATISTICAL_DEVICE")]
        public ActionResult StatisticalDevice()
        {
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];

            int departmetnId = -1;

            if (session.GroupID == "MANAGER" || session.GroupID == "DIRECTOR")
            {
                departmetnId = Int32.Parse(data.UserLogins.Where(x => x.UserName == session.UserName).Select(x => x.Email).FirstOrDefault() ?? "0");
            }

            ViewData["TypeOfDevice"] = data.DeviceTypes.ToList();

            var lstdv = data.StatisticalDevice(departmetnId).ToList();
            return View(lstdv);
        }
        // [HttpPost]
        public ActionResult SearchStatisticalDevice(FormCollection collection)
        {
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];

            int departmetnId = -1;

            if (session.GroupID == "MANAGER" || session.GroupID == "DIRECTOR")
            {
                departmetnId = Int32.Parse(data.UserLogins.Where(x => x.UserName == session.UserName).Select(x => x.Email).FirstOrDefault() ?? "0");
            }

            ViewData["TypeOfDevice"] = data.DeviceTypes.ToList();
            int? Status = Convert.ToInt32(collection["Status"]);
            int? TypeOfDevice = Convert.ToInt32(collection["TypeOfDevice"]);
            var charts = data.StatisticalDevice(departmetnId).ToList();
            if (Status == -1 & TypeOfDevice != 0) { 
                charts = data.StatisticalDevice(departmetnId).Where(x => x.TypeOfDevice == TypeOfDevice).ToList(); 
            }
            else if (TypeOfDevice == 0 & Status != -1) { 
                charts = data.StatisticalDevice(departmetnId).Where(x => x.Status == Status).ToList(); 
            }
            else if (Status != -1 & TypeOfDevice != 0) { 
                charts = data.StatisticalDevice(departmetnId).Where(x => x.Status == Status & x.TypeOfDevice == TypeOfDevice).ToList(); 
            }
            ViewBag.status = Status;
            ViewBag.type = TypeOfDevice;
            var model = charts.ToList();
            return View("StatisticalDevice", model);
        }
        [HasCredential(RoleID = "EXPORT_STATISTICAL_DEVICE")]
        public JsonResult ExportStatisticalDevice()
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
            data.Configuration.ProxyCreationEnabled = false;
            var charts = data.StatisticalDevice(departmetnId).Select(i => new { i.DeviceCode, i.DeviceName, i.PriceOne, i.TimeUse, i.TimeRepair, i.SumPrice });
            var model = charts.ToList();
            using (StringWriter sw = new StringWriter())
            {
                using (System.Web.UI.HtmlTextWriter htw = new System.Web.UI.HtmlTextWriter(sw))
                {
                    GridView grid = new GridView();
                    grid.DataSource = model;
                    grid.DataBind();
                    Response.ClearContent();
                    Response.Buffer = true;
                    string strDateFormat = string.Empty;
                    strDateFormat = string.Format("{0:yyyy-MMM-dd-hh-mm-ss}", DateTime.Now);
                    Response.AddHeader("content-disposition", "attachment; filename=UserDetails_" + strDateFormat + ".xlxs");
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
                ViewBag.Sw
            }, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        [HasCredential(RoleID = "VIEW_EMPLOYEE")]
        public JsonResult GetEmployees(int id)
        {
            data.Configuration.ProxyCreationEnabled = false;
            var Employees = data.Users.Find(id);
            return Json(new
            {
                data = Employees,
            }, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]
        [ValidateInput(false)]
        [HasCredential(RoleID = "EDIT_EMPLOYEE")]
        public JsonResult EditEmployees(int Id, string UserName, string FullName, string PhoneNumber, string Email, string Department, string Position, string Address)
        {
            bool result = true;
            data.UpdateUser(Id, UserName, null, FullName, Email, PhoneNumber, Address, Department, Position, null, 0);
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [HasCredential(RoleID = "ADD_TYPE_COMPONAN")]
        public JsonResult AddTypeChidren(int TypeChidren, int TypeParent)
        {
            bool result = false;
            // Check xem đã tồn tại loại Cha-con
            var listdvt = data.DeviceTypeComponantTypes.Where(x => x.TypeSymbolChildren == TypeChidren && x.TypeSymbolParents == TypeParent).Where(x => x.IsDeleted == false).ToList();
            if (listdvt.Count() > 0)
            { result = false; }
            else
            {
                data.AddTypeChidren(TypeChidren, TypeParent, null);
                result = true;
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult SearchDeviceComponant(int TypeChidren)
        {
            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];
            var lst = data.SearchDevice(null, TypeChidren, null, null, null,session.UserName).Where(x => (x.Status == 0 || x.Status == 1) & x.StatusRepair != 1 & x.ParentId == null).ToList();
            var result = new { lst };
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]

        [HasCredential(RoleID = "ADD_DEVICE_DEVICE")]
        public JsonResult AddDeviceOfDevice(string dvChild, int dvParent, int TypeChild, int TypeParent, int Type_TypeCom)
        {
            var lstId = dvChild.Split(',');
            for (int i = 0; i < lstId.Length; i++)
            {
                if (!lstId[i].Equals(""))
                    data.AddDeviceOfDevice(dvParent, Convert.ToInt32(lstId[i]), TypeChild, TypeParent, Type_TypeCom);
            }
            bool result = true;
            return Json(result, JsonRequestBehavior.AllowGet);
        }
        [HttpPost]

        [HasCredential(RoleID = "DELETE_DEVICE_DEVICE")]
        public JsonResult DeleteDvComponent(int dvChild, int dvParent, string Resons)
        {
            data.DeleteDeviceOfDevice(dvParent, dvChild, Resons);
            bool result = true;
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        public class Com
        {
            public int Type_TypeCom { get; set; }
            public string DeviceCode { get; set; }
            public string Name { get; set; }
            public int TypeComponant { get; set; }
            public int UserId { get; set; }
            public double Price { get; set; }
            public int Project { get; set; }
            public string Config { get; set; }
            public DateTime PurchaseDate { get; set; }
            public DateTime Guarantee { get; set; }
            public int SupplierId { get; set; }
            public string PurchaseContract { get; set; }
            public string Notes { get; set; }
            public int status { get; set; }
            public int IdParent { get; set; }
            public int TypeParent { get; set; }
            public DateTime DateAdd { get; set; }

        }
        [HttpPost]
        [ValidateInput(false)]
        [HasCredential(RoleID = "ADD_DEVICE_DEVICE")]
        public JsonResult AddDeviceComponantNew(Com com)
        {
            // Xét null tránh bị lỗi kiểu dữ liệu
            if (com.Config == null || com.Config.Trim() == "")
            {
                com.Config = "";
            }
            int? Project = com.Project.Equals(0) ? (int?)null : Convert.ToInt32(com.Project);
            int? SupplierId = com.SupplierId.Equals(0) ? (int?)null : Convert.ToInt32(com.SupplierId);
            int? UserId = com.UserId.Equals(0) ? (int?)null : Convert.ToInt32(com.UserId);
            DateTime? DateOfPurchase = (com.PurchaseDate).ToString().Equals("1/1/0001 12:00:00 AM") ? (DateTime?)null : Convert.ToDateTime(com.PurchaseDate);
            DateTime? Guarantee = (com.Guarantee).ToString().Equals("1/1/0001 12:00:00 AM") ? (DateTime?)null : Convert.ToDateTime(com.Guarantee);
            bool result = true;
            //Thêm thiết bị mới
            data.AddDevice((com.DeviceCode).Trim(), null, com.Name, com.TypeComponant, null, com.Config, com.Price, com.PurchaseContract, DateOfPurchase, SupplierId, Project, Guarantee, com.Notes, UserId, com.status, null, null, null, com.DateAdd);

            //Thêm vào bảng cha con
            var IdChild = data.Devices.Where(x => x.DeviceCode == com.DeviceCode).Single().Id;
            data.AddDeviceOfDevice(com.IdParent, IdChild, com.TypeComponant, com.TypeParent, com.Type_TypeCom);
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [HasCredential(RoleID = "MANAGER_TYPE_PR_DV")]
        public ActionResult ManagerTypeParent()
        {
            List<TypeComponantOfDevice_Result> numbers = new List<TypeComponantOfDevice_Result>();
            var lstTypeParent = data.DeviceTypeComponantTypes.Where(x => x.IsDeleted == false).Select(x => x.TypeSymbolParents).Distinct().ToList();

            foreach (var item in lstTypeParent)
            {
                var Name_Parent = data.TypeComponantOfDevice(item).Select(i => new { i.TypeSymbolParents, i.NameTypeParents }).FirstOrDefault();
                var lstChild = data.TypeComponantOfDevice(item).Where(x => x.IsDeleted == false).ToList();

                Array a2 = lstChild.ToArray();
                numbers.Add(new TypeComponantOfDevice_Result { NameTypeParents = Name_Parent.NameTypeParents, TypeSymbolParents = Name_Parent.TypeSymbolParents });
            }
            ViewData["TypeParentTypeChild"] = numbers;
            return View();
            // public Array numbers { get; set; }
        }

        [HasCredential(RoleID = "DELETE_TYPE_PR_DV")]
        public ActionResult DeleteTypeChildOfParent(int idChild, int idParent)
        {
            bool result = true;
            // Check xem còn tồn tại thiết bị con thuộc loại bị xóa không ?
            int check = data.DeviceDevices.Where(x => x.TypeSymbolChildren == idChild & x.TypeSymbolParents == idParent & x.IsDeleted == false).Count();
            if (check > 0)
            {
                result = false;
            }
            else
            {
                data.DeleteTypeParentTypeChild(idChild, idParent);
                result = true;
            }
            return Json(result, JsonRequestBehavior.AllowGet);
        }
    }
}