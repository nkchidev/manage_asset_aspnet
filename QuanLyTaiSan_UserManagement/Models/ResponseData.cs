using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace QuanLyTaiSan_UserManagement.Models

{
    public class ResponseData
    {
        public string CONTENT { get; set; }

        public object DATA { get; set; }

        public string ERROR_CODE { get; set; }

        public string MESSAGE { get; set; }

        public bool SUCCESS { get; set; }

        public DataTable DATA_TB { get; set; }
    }

    public class SourceAPI
    {
        public string TOKEN { get; set; }
        public string DOMAIN { get; set; }
        public string SYS_ID { get; set; }
        public string ROUTE { get; set; }
        public string QUERY { get; set; }
        public string DATABASE_TYPE { get; set; }
        public string CONNECTION_STRING { get; set; }
    }
    public class ReportFill
    {
        //public ReportHelper REPORT { get; set; }

        public string REPORT_ID { get; set; }
        public string PATH { get; set; }

        public List<Type_Model> LS_PARAM { get; set; }

        public List<Type_Model> LS_PARAM_SYSTEM { get; set; }

        public bool boolCheck { get; set; } = true;
        public string StrErro { get; set; }
    }

    public class Type_Model
    {
        public string NAME { get; set; }
        public string VALUE { get; set; }


    }
}