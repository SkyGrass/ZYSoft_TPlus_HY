var dialog = {};
function init(opt) {
  const self = (dialog = new Vue({
    el: "#app",
    data() {
      return {
        form: {
          startDate: "",
          endDate: "",
          deptId: "",
          deptCode: "",
          deptName: "",
        },
      };
    },
    methods: {
      openDept() {
        opt.parent.openBaseDataDialog("dept", "选择部门", function (opt) {
          opt = opt[0];
          var id = opt.id,
            code = opt.code,
            name = opt.name;
          self.form.deptName = name;
          self.form.deptId = id;
          self.form.deptCode = code;
          self.$refs.form.validateField("deptName");
        });
      },
      doFilter() {
        this.grid.setFilter([
          [
            { field: "code", type: "like", value: this.queryForm.keyword },
            { field: "name", type: "like", value: this.queryForm.keyword },
          ],
        ]);
      },
      onClearDept() {
        this.form.deptId = "";
      },
    },
    watch: {},
    mounted() {
      this.form = opt.parent.queryForm;
    },
  }));
}

function getSelect() {
  var result = [dialog.form].map(function (m) {
    m.startDate = Date.parse(m.startDate)
      ? dayjs(m.startDate).format("YYYY-MM-DD")
      : "";
    m.endDate = Date.parse(m.endDate)
      ? dayjs(m.endDate).format("YYYY-MM-DD")
      : "";
    return m;
  });

  if (
    result[0].startDate == null ||
    result[0].endDate == null ||
    result[0].deptId == ""
  ) {
    layer.msg("请选择日期和部门后再进行查询!", {
      zIndex: new Date() * 1,
      icon: 5,
    });
    return [];
  }
  return result;
}
