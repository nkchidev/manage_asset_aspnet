using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace QuanLyTaiSan_UserManagement.Models
{
    public class UserLoginMapper
    {
        public string FullName { get; set; }
        public string UserName { get; set; }
        public string GroupId { get; set; }
        public string PassWord { get; set; }
        public int Id { get; set; }
        public string Email { get; set; }
        public int Status { get; set; }
        public string Department { get; set;}
    }
}