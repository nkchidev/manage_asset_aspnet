using Microsoft.AspNet.Identity;
using QuanLyTaiSan_UserManagement.Common;
using QuanLyTaiSan_UserManagement.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace QuanLyTaiSan_UserManagement.Controllers
{
    public class Account_App_NewController : BaseController
    {


        // GET: Account_App_New
        public ActionResult Login_New()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Login_New(LoginModel model)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    var dao = new UserDao();
                    var result = dao.Login(model.UserName, model.Password/*model.Password*/);
                    if (result == 1)
                    {
                        var user = dao.GetById(model.UserName);
                        var userSession = new UserLoginSec();
                        userSession.UserName = user.UserName;
                        userSession.UserID = user.Id;
                        userSession.GroupID = user.GroupID;
                        userSession.DepartmentID = user.Email; // mượn email lưu id đơn vị
                        userSession.TypeAcc = user.Status.ToString(); // mượn Status lưu loại user: 0 thường; 1: quản trị
                        //Gán session thông tin khách hàng
                        LoginUserSession = userSession;
                        // List quyền của ng dùng
                        List<string> privilegeLevelsNew = dao.GetListCredential(user.UserName.Trim());
                        RoleUserSession = privilegeLevelsNew;
                        return RedirectToAction("Index", "Home");
                    }
                    else if (result == 0)
                    {
                        ModelState.AddModelError("", "Tài khoản không tồn tại.");
                    }
                    else if (result == -1)
                    {
                        ModelState.AddModelError("", "Tài khoản đang bị khoá.");
                    }
                    else if (result == -2)
                    {
                        ModelState.AddModelError("", "Mật khẩu không đúng.");
                    }
                    else if (result == -3)
                    {
                        ModelState.AddModelError("", "Tài khoản của bạn không có quyền truy cập ");
                    }
                    else
                    {
                        ModelState.AddModelError("", "đăng nhập không đúng.");
                    }
                }
                catch (Exception ex)
                {
                    logs("ERRO", "Account_App_NewController", "Login_New", ex.Message);
                    ModelState.AddModelError("", "Lỗi: " + ex.Message);


                }
            }
            return View(model);
        }


    }
}