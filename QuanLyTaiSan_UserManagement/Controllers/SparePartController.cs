using QuanLyTaiSan_UserManagement.Common;
using QuanLyTaiSan_UserManagement.Models;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Web.UI.WebControls;

namespace QuanLyTaiSan_UserManagement.Controllers
{
    public class SparePartController : Controller
    {
        QuanLyTaiSanCtyEntities data = new QuanLyTaiSanCtyEntities();
        string Path_root = @"D:\UploadedFilesPhuTung_QLTS";
        string Path_root_2 = @"D:\UploadedFilesPhuTung_QLTS\";
        string Path_file = @"D:/UploadedFilesPhuTung_QLTS/";

        // GET: SparePart
        [HasCredential(RoleID = "VIEW_SPAREPART")]
        public ActionResult SparePart()
        {
            ViewData["TypeOfDevice"] = data.DeviceTypes.ToList();
            var lstDevice = data.SearchDeviceSparePart(null, null).ToList().OrderByDescending(k => k.Id);
            ViewBag.CountDevice = lstDevice.Count();
            return View(lstDevice);

        }

        [HttpPost]
        public ActionResult SearchSparePart(FormCollection collection)
        {
            ViewData["TypeOfDevice"] = data.DeviceTypes.ToList();
            string DeviceName = collection["DeviceName"];
            int? TypeOfDevice = collection["TypeOfDevice"].Equals("") ? (int?)null : Convert.ToInt32(collection["TypeOfDevice"]);
            var lstDevice = data.SearchDeviceSparePart(TypeOfDevice, DeviceName).ToList().OrderByDescending(k => k.Id);
            ViewBag.CountDevice = lstDevice.Count();
            ViewBag.type = TypeOfDevice;
            ViewBag.deviceName = DeviceName;

            var model = lstDevice.ToList();
            return View("SparePart", model);
        }

        [HasCredential(RoleID = "ADD_SPAREPART")]
        public ActionResult AddSparePart()
        {
            ViewData["TypeOfDevice"] = data.DeviceTypes.ToList();
            return View();
        }
        [HttpPost]
        [ValidateInput(false)]

        [HasCredential(RoleID = "ADD_SPAREPART")]
        public ActionResult AddSparePart(FormCollection colection, IEnumerable<HttpPostedFileBase> files)
        {
            try
            {

                int? TypeOfSparePart = colection["TypeOfSparePart"].Equals("") ? (int?)null : Convert.ToInt32(colection["TypeOfSparePart"]);
                String NameSparePart = colection["NameSparePart"];
                int? PriceSparePart = colection["PriceSparePart"].Equals("") ? (int?)null : Convert.ToInt32(colection["PriceSparePart"].Replace(",", ""));
                int? NumSparePart = colection["NumSparePart"].Equals("") ? (int?)null : Convert.ToInt32(colection["NumSparePart"]);
                DateTime? DateAdded = colection["DateAdded"].Equals("") ? (DateTime?)null : Convert.ToDateTime(colection["DateAdded"]);
                String Configuration = colection["Configuration"];
                String Notes = colection["Notes"];
                String SparePartCode = (Convert.ToInt32(data.GetMaxIdSparePart().FirstOrDefault()) + 1).ToString().PadLeft(8, '0');
                data.AddSparePart(TypeOfSparePart, SparePartCode, NameSparePart, PriceSparePart, NumSparePart, DateAdded, Configuration, Notes);
                Insert_file(files, SparePartCode, Convert.ToInt32(SparePartCode));
            }
            catch (Exception ex)
            {
                Response.Write("<script>alert('Đã xảy ra lỗi !');</script>");
                return null;
            }

            return RedirectToAction("SparePart", "SparePart");
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

        [HasCredential(RoleID = "EDIT_SPAREPART")]
        public ActionResult EditSparePart(int id_dv)
        {
            var lstDevice = data.SearchDeviceSparePart(null, null).Where(x => x.Id == id_dv).FirstOrDefault();


            ViewData["TypeOfDevice"] = data.DeviceTypes.ToList();
            ViewBag.type = lstDevice.DeviceType;

            ViewData["historyInOutSparePart"] = data.DeviceSparePartHistories.Where(x => x.SparePartId == id_dv && x.Isdelete == 0).OrderByDescending(x => x.DateAdded).ToList();

            ViewData["DeviceFile"] = data.DeviceFiles.Where(x => x.DeviceId == id_dv).ToList();
            ViewData["DeviceFile_Pic"] = data.DeviceFiles.Where(x => x.DeviceId == id_dv && (x.FileType == "image/png" || x.FileType == "image/jpeg" || x.FileType == "image/gif")).ToList();
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
                    TempData["ERR"] = "Co loi xay ra: " + ex.Message;

                }
            }
            ViewData["DeviceFile_Pic_2"] = lst_file;
            return View(lstDevice);


        }

        [HasCredential(RoleID = "EDIT_SPAREPART")]
        [HttpPost]
        [ValidateInput(false)]
        public ActionResult EditSparePart(FormCollection colection, IEnumerable<HttpPostedFileBase> files)
        {
            int hidden_Id = Convert.ToInt32(colection["hidden_Id"]);
            if (check_file_exists(files, hidden_Id))
            {
                try
                {
                    int? TypeOfSparePart = null;
                    String NameSparePart = colection["NameSparePart"];
                    int? PriceSparePart = colection["PriceSparePart"].Equals("") ? (int?)null : Convert.ToInt32(colection["PriceSparePart"].Replace(",", ""));
                    int? NumSparePart = null;
                    DateTime? DateAdded = colection["DateAdded"].Equals("") ? (DateTime?)null : Convert.ToDateTime(colection["DateAdded"]);
                    String Configuration = colection["Configuration"];
                    String Notes = colection["Notes"];
                    data.UpdateSparePart(hidden_Id, TypeOfSparePart, NameSparePart, PriceSparePart, NumSparePart, DateAdded, Configuration, Notes);
                    Insert_file(files, hidden_Id.ToString().PadLeft(8, '0'), hidden_Id);
                }
                catch
                {

                    TempData["ERR"] = "Co loi xay ra. Vui long thu lai !";
                }
            }
            else
            { }
            return RedirectToAction("EditSparePart", "SparePart", new { id_dv = hidden_Id });
        }

        public bool check_file_exists(IEnumerable<HttpPostedFileBase> files, int? Device_id)
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

        [HasCredential(RoleID = "DELETE_SPAREPART")]
        [HttpPost]
        public JsonResult DeleteSparePart(string Id)
        {
            string a = "," + Id + ",";
            bool result = false;
            int checkdele = data.DeleteDeviceSparePart(a);
            if (checkdele > 0)
                result = true;
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [HasCredential(RoleID = "EXPORT_SPAREPART")]
        public JsonResult ExportSparePart(string TypeOfDevice, string DeviceName)
        {
            int _TypeOfDevice;
            data.Configuration.ProxyCreationEnabled = false;
            if (!string.IsNullOrEmpty(TypeOfDevice))
            {
                _TypeOfDevice = Convert.ToInt32(TypeOfDevice);
            }
            else
            {
                _TypeOfDevice = -1;
            }
            var lstDevice = data.SearchDeviceSparePart(_TypeOfDevice, DeviceName).ToList();
            List<NewConfig> numbers = new List<NewConfig>();
            for (int i = 0; i < lstDevice.Count; ++i)
            {
                var _config = HtmlToPlainText(lstDevice[i].Config);
                numbers.Add(new NewConfig { SparePartName = lstDevice[i].SparePartName, TypeName = lstDevice[i].TypeName, TotalSparePartFomat = lstDevice[i].TotalSparePartFomat, RemainingAmountFomat = lstDevice[i].RemainingAmountFomat, Amountfomat = lstDevice[i].Amountfomat, Config = _config, Notes = lstDevice[i].Notes });
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
            public string SparePartName { get; set; }
            public string TypeName { get; set; }
            public string TotalSparePartFomat { get; set; }
            public string RemainingAmountFomat { get; set; }
            public string Amountfomat { get; set; }
            public string Config { get; set; }
            public string Notes { get; set; }
        }

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


        [HasCredential(RoleID = "NHAP_SPAREPART")]
        [HttpPost]
        public JsonResult SparePart_Add(string id_spare, string Amount, string NumSpare, string DateAdd, string Note)
        {
            bool check = true;
            try
            {
                int _id_spare = Convert.ToInt32(id_spare);
                decimal _Amount = Convert.ToDecimal(Amount.Replace(",", ""));
                int _NumSpare = Convert.ToInt32(NumSpare.Replace(",", ""));
                DateTime _DateAdd = DateTime.ParseExact(DateAdd, "yyyy-MM-dd", CultureInfo.InvariantCulture);
                data.NhapDeviceSparePart(_id_spare, _Amount, _NumSpare, _DateAdd, Note);

            }
            catch (Exception ex)
            {
                check = false;
            }

            return Json(check, JsonRequestBehavior.AllowGet);
        }

        [HasCredential(RoleID = "XUAT_SPAREPART")]
        [HttpPost]
        public JsonResult SparePart_Minus(string id_spare, string NumSpare, string DateAdd, string Note)
        {
            int result = 0;
            try
            {
                int _id_spare = Convert.ToInt32(id_spare);
                int _NumSpare = Convert.ToInt32(NumSpare.Replace(",", ""));
                DateTime _DateAdd = DateTime.ParseExact(DateAdd, "yyyy-MM-dd", CultureInfo.InvariantCulture);
                var lstDevice = data.SearchDeviceSparePart(null, null).Where(x => x.Id == _id_spare).FirstOrDefault();
                if (lstDevice.RemainingAmount < _NumSpare)
                {
                    result = 2;// Số lượng còn lại ko đủ.
                }
                else
                {
                    data.XuatDeviceSparePart(_id_spare, _NumSpare, _DateAdd, Note);
                }

            }
            catch (Exception ex)
            {
                result = 1;
            }

            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [HasCredential(RoleID = "NHAPXUAT_SPAREPART")]
        public ActionResult InOutSparePart()
        {
            ViewData["TypeOfDevice"] = data.DeviceTypes.ToList();
            var lstDevice = data.SearchDeviceSparePartHistory(null, null, null).ToList();
            ViewBag.CountDevice = lstDevice.Count();
            return View(lstDevice);

        }

        [HttpPost]
        public ActionResult SearchInOutSparePart(FormCollection collection)
        {
            ViewData["TypeOfDevice"] = data.DeviceTypes.ToList();
            string DeviceName = collection["DeviceName"];
            string TypeTran = collection["TypeTran"];
            int? TypeOfDevice = collection["TypeOfDevice"].Equals("") ? (int?)null : Convert.ToInt32(collection["TypeOfDevice"]);
            var lstDevice = data.SearchDeviceSparePartHistory(TypeOfDevice, DeviceName, TypeTran).ToList();
            ViewBag.CountDevice = lstDevice.Count();
            ViewBag.type = TypeOfDevice;
            ViewBag.typeTrans = TypeTran;
            ViewBag.deviceName = DeviceName;

            var model = lstDevice.ToList();
            return View("InOutSparePart", model);
        }

        [HasCredential(RoleID = "DELETENHAPXUAT_SPAREPART")]
        public JsonResult DeleteSparePartHis(string Id)
        {
            string a = "," + Id + ",";
            bool result = false;
            int checkdele = data.DeleteDeviceSparePartHistory(a);
            if (checkdele > 0)
                result = true;
            return Json(result, JsonRequestBehavior.AllowGet);
        }


        [HasCredential(RoleID = "EXPORTNHAPXUAT_SPAREPART")]
        public JsonResult ExportSparePartHis(string TypeOfDevice, string TypeTran, string DeviceName)
        {
            int _TypeOfDevice;
            data.Configuration.ProxyCreationEnabled = false;
            if (!string.IsNullOrEmpty(TypeOfDevice))
            {
                _TypeOfDevice = Convert.ToInt32(TypeOfDevice);
            }
            else
            {
                _TypeOfDevice = -1;
            }
            var lstDevice = data.SearchDeviceSparePartHistory(_TypeOfDevice, DeviceName, TypeTran).ToList();
            List<NewConfigHis> numbers = new List<NewConfigHis>();
            for (int i = 0; i < lstDevice.Count; ++i)
            {
                string _date = @String.Format("{0:dd/MM/yyyy}", lstDevice[i].DateAdded);
                numbers.Add(new NewConfigHis { SparePartName = lstDevice[i].SparePartName, TypeName = lstDevice[i].TypeName, NumSparePartfomat = lstDevice[i].NumSparePartfomat, Amountfomat = lstDevice[i].Amountfomat, TypeTrans = lstDevice[i].TransType, DateAdded = _date, Notes = lstDevice[i].Notes });
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
        public class NewConfigHis
        {
            public string SparePartName { get; set; }
            public string TypeName { get; set; }
            public string NumSparePartfomat { get; set; }
            public string Amountfomat { get; set; }
            public string TypeTrans { get; set; }
            public string DateAdded { get; set; }
            public string Notes { get; set; }
        }
    }
}