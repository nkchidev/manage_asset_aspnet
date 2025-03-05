using QuanLyTaiSan_UserManagement;
using QuanLyTaiSan_UserManagement.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace QuanLyTaiSan_UserManagement.Common
{
    public class UserDao
    {


        Encryptor encr = new Encryptor();
        QuanLyTaiSanCtyEntities db = null;
        public UserDao()
        {
            db = new QuanLyTaiSanCtyEntities();
        }

        //public long Insert(User entity)
        //{
        //    db.Users.Add(entity);
        //    db.SaveChanges();
        //    return entity.Id;
        //}
        //public long InsertForFacebook(User entity)
        //{
        //    var user = db.Users.SingleOrDefault(x => x.UserName == entity.UserName);
        //    if (user == null)
        //    {
        //        db.Users.Add(entity);
        //        db.SaveChanges();
        //        return entity.Id;
        //    }
        //    else
        //    {
        //        return user.Id;
        //    }

        //}
        //public bool Update(User entity)
        //{
        //    try
        //    {
        //        var user = db.Users.Find(entity.Id);
        //        user.UserName = entity.UserName;
        //        if (!string.IsNullOrEmpty(entity.PassWord))
        //        {
        //            user.PassWord = entity.PassWord;
        //        }
        //        user.Address = entity.Address;
        //        user.Email = entity.Email;
        //        // user.ModifiedBy = entity.ModifiedBy;
        //        //    user.ModifiedDate = DateTime.Now;
        //        db.SaveChanges();
        //        return true;
        //    }
        //    catch (Exception ex)
        //    {
        //        //logging
        //        return false;
        //    }

        //}

        //public IEnumerable<User> ListAllPaging(string searchString, int page, int pageSize)
        //{
        //    IQueryable<User> model = db.Users;
        //    if (!string.IsNullOrEmpty(searchString))
        //    {
        //        model = model.Where(x => x.UserName.Contains(searchString) || x.Name.Contains(searchString));
        //    }

        //    return model.OrderByDescending(x => x.CreatedDate).ToPagedList(page, pageSize);
        //}

        public UserLogin GetById(string userName)
        {
            return db.UserLogins.SingleOrDefault(x => x.UserName == userName);
        }
        //public User ViewDetail(int id)
        //{
        //    return db.Users.Find(id);
        //}
        public List<string> GetListCredential(string userName)
        {
            var user = db.UserLogins.Single(x => x.UserName == userName);
            var data = (from a in db.Credentials
                        join b in db.UserGroups on a.UserGroupID equals b.ID
                        join c in db.Roles on a.RoleID equals c.ID
                        where b.ID == user.GroupID
                        select new
                        {
                            RoleID = a.RoleID,
                            UserGroupID = a.UserGroupID
                        }).AsEnumerable().Select(x => new Credential()
                        {
                            RoleID = x.RoleID,
                            UserGroupID = x.UserGroupID
                        });
            return data.Select(x => x.RoleID).ToList();

        }
        public int Login(string userName, string passWord)
        {

            var result = db.UserLogins.SingleOrDefault(x => x.UserName.Trim() == userName.Trim() && x.IsDeleted == false);
            if (result == null)
            {
                return 0;
            }
            else
            {
                //if (isLoginAdmin == true)
                //{
                //if (result.GroupID == CommonConstants1.ADMIN_GROUP || result.GroupID == CommonConstants1.MOD_GROUP)
                //{
                //if (result. Status == false)
                //{
                //    return -1;
                //}
                //else
                //{
                string de_pass = encr.Encrypt(passWord.Trim(), userName.Trim(), true);
                if (de_pass == result.PassWord.Trim())
                {
                    return 1;
                }
                else
                {
                    return -2;
                }
                //}
            }

        }

        //public bool ChangeStatus(long id)
        //{
        //    var user = db.Users.Find(id);
        //    user.Status = !user.Status;
        //    db.SaveChanges();
        //    return user.Status;
        //}

        //public bool Delete(int id)
        //{
        //    try
        //    {
        //        var user = db.Users.Find(id);
        //        db.Users.Remove(user);
        //        db.SaveChanges();
        //        return true;
        //    }
        //    catch (Exception)
        //    {
        //        return false;
        //    }

        //}

        //public bool CheckUserName(string userName)
        //{
        //    return db.Users.Count(x => x.UserName == userName) > 0;
        //}
        //public bool CheckEmail(string email)
        //{
        //    return db.Users.Count(x => x.Email == email) > 0;
        //}

        public bool AddUserGroup(string ID, string Name)
        {
            bool a = true;
            var Check = db.UserGroups.Where(x => x.ID == ID).Count();
            if (Check > 0)
            {
                a = false;
            }
            else
            {
                var entity = new UserGroup { ID = ID, Name = Name };
                db.UserGroups.Add(entity);
                db.SaveChanges();
                a = true;
            }
            return a;
        }

        public bool DeleteUserGroup(string ID)
        {
            bool a = true;
            // Kiểm tra nhóm quyền chứa quyền nào ko ?
            var Check = db.Credentials.Where(x => x.UserGroupID == ID).Count();
            // Kiểm tra người dùng còn sử dụng nhóm quyền ko ?
            var Check_1 = db.UserLogins.Where(x => x.GroupID == ID).Count();
            if (Check > 0 || Check_1 > 0)
            {
                a = false;
            }
            else
            {

                var UserGroup = db.UserGroups.Find(ID);
                db.UserGroups.Remove(UserGroup);
                db.SaveChanges();
                a = true;
            }
            return a;
        }

        public bool AddRoleForGroup(string lstRoleId, string GroupId)
        {
            bool a = true;
            var lstRole = lstRoleId.Split(',');
            for (int i = 0; i < lstRole.Length; i++)
            {
                if (!lstRole[i].Equals(""))
                {
                    var entity = new Credential { RoleID = lstRole[i].Trim(), UserGroupID = GroupId };
                    db.Credentials.Add(entity);
                    db.SaveChanges();
                }
            }

            return a;
        }


        public bool UpdateRoleUser(string FullName, string UserName, string Role, string PassWord, string Department, string TypeAcc)
        {
            bool result = true;
            //Check đã tồn tại username
            var Check = db.UserLogins.Where(x => x.UserName == UserName & x.IsDeleted == false).Count();
            if (Check > 0)
            {
                result = false;
            }
            else
            {
                // Mượn email lưu mã phòng/ban user
                // Mượn status lưu loại tài khoản: 0 thường; 1 quản trị
                int? TypeAccNew = Convert.ToInt32(TypeAcc);
                var entity = new UserLogin { FullName = FullName, UserName = UserName, GroupID = Role, PassWord = PassWord, Email = Department, IsDeleted = false, Status = TypeAccNew };
                db.UserLogins.Add(entity);
                db.SaveChanges();
                result = true;
            }
            return result;
        }

        public bool UpdateRole(int ID, string FullName, string UserName, string Role, string PassWord, string Department, string TypeAcc)
        {
            bool result = true;
            var user = db.UserLogins.Find(ID);
            user.FullName = FullName;
            user.GroupID = Role;
            user.PassWord = PassWord;
            user.Email = Department; // Mượn Email để lưu phòng ban user
            user.Status = Convert.ToInt32(TypeAcc); // Mượn status để lưu loại tài khoản: 0 thường, 1 quản trị
            db.SaveChanges();
            return result;
        }

        public bool DeleteRoleUser(int ID)
        {
            bool result = true;

            var user = db.UserLogins.Find(ID);
            user.IsDeleted = true;

            db.SaveChanges();
            return result;
        }
    }
}