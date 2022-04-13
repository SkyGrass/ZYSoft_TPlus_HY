using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Ufida.T.EAP.AppBase;
using Ufida.T.BAP.Web.Base;
using System.Web.UI.WebControls;
using Chanjet.ZYSoft.HY.Interface;
using Ufida.T.EAP.Aop;
using Ufida.T.EAP.DataStruct.Context;
using System.Web;
using Ufida.T.EAP.Dal;

namespace Chanjet.ZYSoft.HY.UIP
{
    public class HYPage : IAppHandler
    {
        GenericController controller;
        IHY interfaceService;
        Label lblUserName;
        Label lbUserId;
        Label lbAccount;
        public void AppEventHandler(object sender, AppEventArgs e)
        {
            controller = sender as GenericController;
            lblUserName = controller.GetViewControl("lblUserName") as Label;
            lbUserId = controller.GetViewControl("lbUserId") as Label;
            lbAccount = controller.GetViewControl("lbAccount") as Label;
            interfaceService = ServiceFactory.getService<IHY>();
            Page_Load(sender, e);
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            UserInfo userInfo = HttpContext.Current.Session["UserInfo"] as UserInfo;
            lblUserName.Text += userInfo.PersonName;
            lbUserId.Text += userInfo.UserID;
            lbAccount.Text += userInfo.AccountID;
        }
    }
}
