<%@ WebHandler Language="C#" Class="HYHandler" %>

using System;
using System.Web;
using System.Data;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Collections.Generic;
using System.Xml;
using System.Net;
using System.IO;
public class HYHandler : IHttpHandler
{
    public class Result
    {
        public string state { get; set; }
        public object data { get; set; }
        public string msg { get; set; }
    }

    public class TResult
    {
        public string Result { get; set; }
        public string Message { get; set; }
        public object Data { get; set; }
    }

    /// <summary>
    /// 表单数据项
    /// </summary>
    public class FormItemModel
    {
        /// <summary>
        /// 表单键，request["key"]
        /// </summary>
        public string Key { set; get; }
        /// <summary>
        /// 表单值,上传文件时忽略，request["key"].value
        /// </summary>
        public string Value { set; get; }
        /// <summary>
        /// 是否是文件
        /// </summary>
        public bool IsFile
        {
            get
            {
                if (FileContent == null || FileContent.Length == 0)
                    return false;

                if (FileContent != null && FileContent.Length > 0 && string.IsNullOrWhiteSpace(FileName))
                    throw new Exception("上传文件时 FileName 属性值不能为空");
                return true;
            }
        }
        /// <summary>
        /// 上传的文件名
        /// </summary>
        public string FileName { set; get; }
        /// <summary>
        /// 上传的文件内容
        /// </summary>
        public Stream FileContent { set; get; }
    }

    /// <summary>
    /// 产成品 入库
    /// </summary>
    public class ProductIn
    {
        /// <summary>
        /// TOKEN
        /// </summary>
        public string Token { get; set; }

        /// <summary>
        /// 制单日期
        /// </summary>
        public string FDate { get; set; }

        /// <summary>
        /// 部门编码
        /// </summary>
        public string FDeptCode { get; set; }


        /// <summary>
        ///  仓库编码
        /// </summary>
        public string FWhCode { get; set; }


        /// <summary>
        /// 备注
        /// </summary>
        public string FMemo { get; set; }


        /// <summary>
        /// 明细
        /// </summary>
        public List<ProductInEntry> Entry { get; set; }
    }

    public class ProductInEntry
    {
        /// <summary>
        /// 存货编码
        /// </summary>
        public string FInvCode { get; set; }

        /// <summary>
        /// 批号 
        /// </summary>
        public string FBatch { get; set; }

        /// <summary>
        ///  数量
        /// </summary>
        public decimal FQuantity { get; set; }

        /// <summary>
        ///  件数
        /// </summary>
        public decimal FNum { get; set; }

        /// <summary>
        /// 生产日期 
        /// </summary>
        public string FProductionDate { get; set; }

        /// <summary>
        /// 失效日期
        /// </summary>
        public string FExpiryDate { get; set; }

        /// <summary>
        ///  单价
        /// </summary>
        public decimal FPrice { get; set; }

        /// <summary>
        ///  金额
        /// </summary>
        public decimal FAmount { get; set; }

        // <summary>
        /// 来源单据ID
        /// </summary>
        public string FSourceBillID { get; set; }

        /// <summary>
        /// 来源明细单据ID 
        /// </summary>
        public string FSourceBillEntryID { get; set; }


        /// <summary>
        ///  来源单据编号
        /// </summary>
        public string FSourceBillNo { get; set; }


        /// <summary>
        ///  人员名称
        /// </summary>
        public string FPersonName { get; set; }

    }


    public void ProcessRequest(HttpContext context)
    {
        ZYSoft.DB.Common.Configuration.ConnectionString = DBMethods.LoadXML("ConnectionString");
        context.Response.ContentType = "text/plain";
        if (context.Request.Form["SelectApi"] != null)
        {
            string result = "";
            switch (context.Request.Form["SelectApi"].ToLower())
            {
                case "getconnect":
                    result = ZYSoft.DB.Common.Configuration.ConnectionString;
                    break;
                case "getdialogconf":
                    string dialogType = context.Request.Form["dialogType"] ?? "custom";
                    result = DBMethods.LoadJSON(dialogType);
                    break;
                case "getdept":
                    string keyword = context.Request.Form["keyword"] ?? "";
                    result = DBMethods.GetDept(keyword);
                    break;
                case "getwarehouse":
                    keyword = context.Request.Form["keyword"] ?? "";
                    result = DBMethods.GetWarehouse(keyword);
                    break;
                case "getperson":
                    keyword = context.Request.Form["keyword"] ?? "";
                    string deptId = context.Request.Form["deptId"] ?? context.Request.QueryString["deptId"];
                    result = DBMethods.GetPerson(deptId, keyword);
                    break;
                case "getplanlist":
                    deptId = context.Request.Form["deptId"] ?? "";
                    string startDate = context.Request.Form["startDate"] ?? "";
                    string endDate = context.Request.Form["endDate"] ?? "";
                    result = DBMethods.GetPlanList(deptId, startDate, endDate);
                    break;
                case "save":
                    string formStr = context.Request.Form["formStr"] ?? "";
                    result = DBMethods.SaveForm(formStr);
                    break;
                default: break;
            }
            context.Response.Write(result);
        }
        else
        {
            context.Response.Write("服务正在运行!");
        }
    }

    public class DBMethods
    {
        #region 查询部门
        public static string GetDept(string keyword = "")
        {
            var list = new List<Result>();
            try
            {
                string sql = string.IsNullOrEmpty(keyword) ? string.Format(@"select id,code,name from AA_Department") :
                        string.Format(@"select id,code,name from AA_Department where code like '%{0}%' or name like '%{0}%'", keyword);
                DataTable dt = ZYSoft.DB.BLL.Common.ExecuteDataTable(sql);
                if (dt != null && dt.Rows.Count > 0)
                {
                    return JsonConvert.SerializeObject(new
                    {
                        state = dt.Rows.Count > 0 ? "success" : "error",
                        data = dt,
                        msg = ""
                    });
                }
                else
                {
                    return JsonConvert.SerializeObject(new
                    {
                        state = "error",
                        data = new List<string>(),
                        msg = "没有查询到数据!"
                    });
                }
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new
                {
                    state = "error",
                    data = new List<string>(),
                    msg = ex.Message
                });
            }
        }
        #endregion

        #region 查询仓库
        public static string GetWarehouse(string keyword = "")
        {
            var list = new List<Result>();
            try
            {
                string sql = string.IsNullOrEmpty(keyword) ? string.Format(@"select id,code,name from AA_Warehouse") :
                        string.Format(@"select id,code,name from AA_Warehouse where code like '%{0}%' or name like '%{0}%'", keyword);
                DataTable dt = ZYSoft.DB.BLL.Common.ExecuteDataTable(sql);
                if (dt != null && dt.Rows.Count > 0)
                {
                    return JsonConvert.SerializeObject(new
                    {
                        state = dt.Rows.Count > 0 ? "success" : "error",
                        data = dt,
                        msg = ""
                    });
                }
                else
                {
                    return JsonConvert.SerializeObject(new
                    {
                        state = "error",
                        data = new List<string>(),
                        msg = "没有查询到数据!"
                    });
                }
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new
                {
                    state = "error",
                    data = new List<string>(),
                    msg = ex.Message
                });
            }
        }
        #endregion

        #region 查询人员
        public static string GetPerson(string deptId, string keyword)
        {
            var list = new List<Result>();
            try
            {
                string sql = string.IsNullOrEmpty(keyword) ? string.Format(@"select id,code,name from AA_Person where iddepartment = '{0}' ", deptId) :
                        string.Format(@"select id,code,name from AA_Person where iddepartment = '{0}' and (code like '%{1}%' or name like '%{1}%')", deptId, keyword);
                DataTable dt = ZYSoft.DB.BLL.Common.ExecuteDataTable(sql);
                if (dt != null && dt.Rows.Count > 0)
                {
                    return JsonConvert.SerializeObject(new
                    {
                        state = dt.Rows.Count > 0 ? "success" : "error",
                        data = dt,
                        msg = ""
                    });
                }
                else
                {
                    return JsonConvert.SerializeObject(new
                    {
                        state = "error",
                        data = new List<string>(),
                        msg = "没有查询到数据!"
                    });
                }
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new
                {
                    state = "error",
                    data = new List<string>(),
                    msg = ex.Message
                });
            }
        }
        #endregion

        #region 查询生产计划单
        public static string GetPlanList(string deptId, string startDate, string endDate)
        {
            var list = new List<Result>();
            try
            {
                string sql =
                        string.Format(@"select * from  [dbo].[v_ZYSoft_DayPlan] where VoucherDate between '{0} 00:00:00' and '{1} 23:59:59' and iddepartment = '{2}'", startDate, endDate, deptId);
                DataTable dt = ZYSoft.DB.BLL.Common.ExecuteDataTable(sql);
                if (dt != null && dt.Rows.Count > 0)
                {
                    return JsonConvert.SerializeObject(new
                    {
                        state = dt.Rows.Count > 0 ? "success" : "error",
                        data = dt,
                        msg = ""
                    });
                }
                else
                {
                    return JsonConvert.SerializeObject(new
                    {
                        state = "error",
                        data = new List<string>(),
                        msg = "没有查询到数据!"
                    });
                }
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new
                {
                    state = "error",
                    data = new List<string>(),
                    msg = ex.Message
                });
            }
        }
        #endregion

        #region 上报记录
        public static string SaveForm(string str)
        {
            try
            {
                ProductIn productIn = JsonConvert.DeserializeObject<ProductIn>(str);
                if (productIn != null && productIn.Entry != null && productIn.Entry.Count > 0)
                {
                    return SaveBill<ProductIn>(productIn);
                }
                else
                {
                    return JsonConvert.SerializeObject(new
                    {
                        state = "error",
                        data = new List<string>(),
                        msg = "未能获取到上报信息,请核实!"
                    });
                }
            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new
                {
                    state = "error",
                    data = new List<string>(),
                    msg = "上报信息发生异常,原因:" + ex.Message
                });
            }
        }
        #endregion


        /*保存单据*/
        public static string SaveBill<T>(T formData)
        {
            try
            {
                var WsUrl = LoadXML("WsUrl");
                string methosName = LoadXML("Method");
                var formDatas = new List<FormItemModel>();
                //添加文本
                formDatas.Add(new FormItemModel()
                {
                    Key = "MethodName",
                    Value = methosName
                });          //添加文本
                formDatas.Add(new FormItemModel()
                {
                    Key = "JSON",
                    Value = JsonConvert.SerializeObject(formData)
                });

                AddLogErr("SaveBill", JsonConvert.SerializeObject(formDatas));

                var json = DoPost(WsUrl, formDatas);
                TResult result = JsonConvert.DeserializeObject<TResult>(json);
                return JsonConvert.SerializeObject(new
                {
                    state = result.Result == "Y" ? "success" : "error",
                    data = "",
                    msg = result.Result == "Y" ? "生成单据成功!" : result.Message
                });

            }
            catch (Exception ex)
            {
                return JsonConvert.SerializeObject(new
                {
                    state = "error",
                    data = "",
                    msg = "生成单据发生异常!原因:" + ex.Message
                });
            }
        }

        public static string DoPost(string url, List<FormItemModel> formItems, CookieContainer cookieContainer = null, string refererUrl = null,
            System.Text.Encoding encoding = null, int timeOut = 20000)
        {
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            #region 初始化请求对象
            request.Method = "POST";
            request.Timeout = timeOut;
            request.Accept = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8";
            request.KeepAlive = true;
            request.UserAgent = "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.57 Safari/537.36";
            if (!string.IsNullOrEmpty(refererUrl))
                request.Referer = refererUrl;
            if (cookieContainer != null)
                request.CookieContainer = cookieContainer;
            #endregion

            string boundary = "----" + DateTime.Now.Ticks.ToString("x");//分隔符
            request.ContentType = string.Format("multipart/form-data; boundary={0}", boundary);
            //请求流
            var postStream = new MemoryStream();
            #region 处理Form表单请求内容
            //是否用Form上传文件
            var formUploadFile = formItems != null && formItems.Count > 0;
            if (formUploadFile)
            {
                //文件数据模板
                string fileFormdataTemplate =
                    "\r\n--" + boundary +
                    "\r\nContent-Disposition: form-data; name=\"{0}\"; filename=\"{1}\"" +
                    "\r\nContent-Type: application/octet-stream" +
                    "\r\n\r\n";
                //文本数据模板
                string dataFormdataTemplate =
                    "\r\n--" + boundary +
                    "\r\nContent-Disposition: form-data; name=\"{0}\"" +
                    "\r\n\r\n{1}";
                foreach (var item in formItems)
                {
                    string formdata = null;
                    if (item.IsFile)
                    {
                        //上传文件
                        formdata = string.Format(
                            fileFormdataTemplate,
                            item.Key, //表单键
                            item.FileName);
                    }
                    else
                    {
                        //上传文本
                        formdata = string.Format(
                            dataFormdataTemplate,
                            item.Key,
                            item.Value);
                    }

                    //统一处理
                    byte[] formdataBytes = null;
                    //第一行不需要换行
                    if (postStream.Length == 0)
                        formdataBytes = System.Text.Encoding.UTF8.GetBytes(formdata.Substring(2, formdata.Length - 2));
                    else
                        formdataBytes = System.Text.Encoding.UTF8.GetBytes(formdata);
                    postStream.Write(formdataBytes, 0, formdataBytes.Length);

                    //写入文件内容
                    if (item.FileContent != null && item.FileContent.Length > 0)
                    {
                        using (var stream = item.FileContent)
                        {
                            byte[] buffer = new byte[1024];
                            int bytesRead = 0;
                            while ((bytesRead = stream.Read(buffer, 0, buffer.Length)) != 0)
                            {
                                postStream.Write(buffer, 0, bytesRead);
                            }
                        }
                    }
                }
                //结尾
                var footer = System.Text.Encoding.UTF8.GetBytes("\r\n--" + boundary + "--\r\n");
                postStream.Write(footer, 0, footer.Length);
            }
            else
            {
                request.ContentType = "application/x-www-form-urlencoded";
            }
            #endregion

            request.ContentLength = postStream.Length;

            #region 输入二进制流
            if (postStream != null)
            {
                postStream.Position = 0;
                //直接写入流
                Stream requestStream = request.GetRequestStream();

                byte[] buffer = new byte[1024];
                int bytesRead = 0;
                while ((bytesRead = postStream.Read(buffer, 0, buffer.Length)) != 0)
                {
                    requestStream.Write(buffer, 0, bytesRead);
                }
                postStream.Close();//关闭文件访问
            }
            #endregion

            HttpWebResponse response = (HttpWebResponse)request.GetResponse();
            if (cookieContainer != null)
            {
                response.Cookies = cookieContainer.GetCookies(response.ResponseUri);
            }

            using (Stream responseStream = response.GetResponseStream())
            {
                using (StreamReader myStreamReader = new StreamReader(responseStream, encoding ?? System.Text.Encoding.UTF8))
                {
                    string retString = myStreamReader.ReadToEnd();
                    return retString;
                }
            }
        }

        public static void AddLogErr(string SPName, string ErrDescribe)
        {
            string tracingFile = Path.Combine(HttpContext.Current.Request.PhysicalApplicationPath, "ZYSoftLog");
            if (!Directory.Exists(tracingFile))
                Directory.CreateDirectory(tracingFile);
            string fileName = DateTime.Now.ToString("yyyyMMdd") + ".txt";
            tracingFile += fileName;
            if (tracingFile != string.Empty)
            {
                FileInfo file = new FileInfo(tracingFile);
                StreamWriter debugWriter = new StreamWriter(file.Open(FileMode.Append, FileAccess.Write, FileShare.ReadWrite));
                debugWriter.WriteLine(SPName + " (" + DateTime.Now.ToString() + ") " + " :");
                debugWriter.WriteLine(ErrDescribe);
                debugWriter.WriteLine();
                debugWriter.Flush();
                debugWriter.Close();
            }
        }

        #region 读取配置
        public static string LoadJSON(string key)
        {
            string filename = HttpContext.Current.Request.PhysicalApplicationPath + @"dialogConf.json";
            if (File.Exists(filename))
            {
                using (StreamReader sr = new StreamReader(filename, encoding: System.Text.Encoding.UTF8))
                {
                    JsonTextReader reader = new JsonTextReader(sr);
                    JObject jo = (JObject)JToken.ReadFrom(reader);
                    return JsonConvert.SerializeObject(new
                    {
                        state = jo[key] == null ? "error" : "success",
                        msg = jo[key] == null ? "未能查询到配置" : "成功",
                        data = jo[key]
                    });
                }
            }
            else
            {
                return "";
            }
        }
        #endregion

        public static string LoadXML(string key)
        {
            string filename = HttpContext.Current.Request.PhysicalApplicationPath + @"zysoftweb.config";
            XmlDocument xmldoc = new XmlDocument();
            xmldoc.Load(filename);
            XmlNode node = xmldoc.SelectSingleNode("/configuration/appSettings");

            string return_value = string.Empty;
            foreach (XmlElement el in node)//读元素值 
            {
                if (el.Attributes["key"].Value.ToLower().Equals(key.ToLower()))
                {
                    return_value = el.Attributes["value"].Value;
                    break;
                }
            }

            return return_value;
        }
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

}