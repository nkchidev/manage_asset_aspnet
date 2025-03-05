using System;
using System.Globalization;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using QuanLyTaiSan_UserManagement.Models;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.SqlClient;
using QuanLyTaiSan_UserManagement.Attribute;
using QuanLyTaiSan_UserManagement.Common;

namespace QuanLyTaiSan_UserManagement.Controllers
{

    public class UserRoleController : Controller
    {
        QuanLyTaiSanCtyEntities data = new QuanLyTaiSanCtyEntities();
        Encryptor encr = new Encryptor();
        [HasCredential(RoleID = "VIEW_USER")]
        public ActionResult UserIndex()
        {
            var dao = new UserDao();

            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];
            int? departmetnId = -1;

            if (session.GroupID == "MANAGER" || session.GroupID == "DIRECTOR")
            {
                departmetnId = Int32.Parse(data.UserLogins.Where(x => x.UserName == session.UserName).Select(x => x.Email).FirstOrDefault() ?? "0");

                ViewData["Roles"] = data.UserGroups.ToList().Where(x => x.ID == "MANAGER").ToList();
            }
            else
            {
                ViewData["Roles"] = data.UserGroups.ToList().Where(x => x.ID == "MANAGER" || x.ID == "ADMIN" || x.ID == "DIRECTOR").ToList();
            }

            var allDepartment = data.GetUnitsById(departmetnId, session.UserName).ToList();

            var users = data.UserLogins.Where(x => x.IsDeleted == false).ToList();

            var userJoin = from p in allDepartment join u in users on p.Id equals int.Parse(u.Email) select u;

            var userRole = new List<InformationUser>();

            foreach (var item in userJoin)
            {
                if (!string.IsNullOrEmpty(item.GroupID))
                {
                    var NameGrRole = data.UserGroups.Where(x => x.ID == item.GroupID).Select(x => x.Name).First();
                    userRole.Add(new InformationUser()
                    {
                        Id = item.Id,
                        Username = item.UserName,
                        RoleGroupID = item.GroupID,
                        RoleGroupName = NameGrRole,
                        FullName = item.FullName,

                    });
                }
                else
                {
                    userRole.Add(new InformationUser()
                    {
                        Id = item.Id,
                        Username = item.UserName,
                        RoleGroupID = item.GroupID,
                        RoleGroupName = "Chưa được phân quyền",
                        FullName = item.FullName,

                    });
                }
            }

            ViewData["Department"] = data.GetUnitsById(departmetnId, session.UserName).ToList();
            ViewData["Users"] = userRole;
            ViewData["GroupId"] = session.GroupID;
            return View();
        }

        [HttpPost]
        [ValidateInput(false)]
        //[ValidateAntiForgeryToken]
        [HasCredential(RoleID = "ADD_USER")]
        public ActionResult RegisterUser(string FullName, string Role, string Username, string Password,string Department, string TypeAcc)
        {
            var dao = new UserDao();
            var result = dao.UpdateRoleUser(FullName, Username, Role, encr.Encrypt(Password, Username, true), Department, TypeAcc);
            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult GetListDepartmentByIds(int id)
        {

            var session = (UserLoginSec)Session[CommonConstants.USER_SESSION];

            int departmetnId = -1;
       
            if(session.GroupID == "DIRECTOR" || session.GroupID == "MANAGER")
            {
                departmetnId = Int32.Parse(data.UserLogins.Where(x => x.UserName == session.UserName).Select(x => x.Email).FirstOrDefault() ?? "0");
            }
            var models = data.GetUnitsById(departmetnId, session.UserName).ToList();

            var result = models.Where(x => x.ParentId == id).Select(x => x).ToList(); 

            return Json(new { result }, JsonRequestBehavior.AllowGet); 
        }

        [HttpGet]
        [HasCredential(RoleID = "CHANGE_INFO_USER")]
        public JsonResult GetInfoAccount(string userId)
        {
            data.Configuration.ProxyCreationEnabled = false;
            var u = userId.Trim();
            var lstInfo = data.UserLogins.Where(x => x.UserName == u).FirstOrDefault();
            var _pass = encr.Decrypt(lstInfo.PassWord.Trim(), lstInfo.UserName.Trim(), true);
            List<string> Pass1 = new List<string>(_pass.Split(new string[] { "[|]" }, StringSplitOptions.None));
            lstInfo.PassWord = Pass1[0];
            var departments = data.GetUnitsById(Int32.Parse(lstInfo.Email ?? "0"), lstInfo.UserName).ToList();

            var userMapper = new UserLoginMapper()
            {
                Id = lstInfo.Id,
                UserName = lstInfo.UserName,
                Email = lstInfo.Email,
                Department = departments.Where(x => x.HasChild == 1).Select(x => x.Id).FirstOrDefault().ToString(),
                FullName = lstInfo.UserName,
                GroupId = lstInfo.GroupID,
                PassWord = Pass1[0],
                Status = lstInfo.Status ?? 0
            };

            return Json(new { userMapper }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        [HasCredential(RoleID = "CHANGE_USER_GROUP")]
        public JsonResult ChangeRoleByUserId(int ID, string FullName, string Username, string Role, string Password, string Department, string TypeAcc)
        {
            // bool result = true;
            var dao = new UserDao();
            var result = dao.UpdateRole(ID, FullName, Username, Role, encr.Encrypt(Password, Username, true), Department, TypeAcc);
            return Json(result);
        }


        [HttpPost]
        [HasCredential(RoleID = "DELETE_USER")]
        public JsonResult DeleteUser(int userId)
        {
            var dao = new UserDao();
            var result = dao.DeleteRoleUser(userId);
            return Json(result);
        }
    }
}