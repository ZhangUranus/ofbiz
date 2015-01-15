<div class="container">
	<div class="row">
      <form id="searchForm" class="form-horizontal span24">
        <div class="row">
          <div class="control-group span8">
            <label class="control-label">商品分类：</label>
            <div class="controls">
              <select name="prodCategoryId" class="input-normal"> 
                <option value="">请选择</option>
                <#list productCategoryVOs as productCategoryVO>
					<option value="${productCategoryVO.productCategoryId}">${productCategoryVO.categoryName}</option>
				</#list>
              </select>
            </div>
          </div>
          <div class="span3 offset2">
            <button type="button" id="btnSearch" class="button button-primary">搜索</button>
          </div>
        </div>
      </form>
    </div>
    <div class="search-grid-container">
      <div id="grid"></div>
    </div>
</div>

<div id="content" class="hide">
      <form id="J_Form" class="form-horizontal" action="../data/edit.php?a=1">
        <div class="row">
          <div class="control-group span8">
            <label class="control-label"><s>*</s>品名规格：</label>
            <div class="controls">
              <input name="prodName" type="text" data-rules="{required:true}" class="input-normal control-text">
            </div>
          </div>
          <div class="control-group span8">
            <label class="control-label"><s>*</s>商品型号：</label>
            <div class="controls">
              <input name="prodModel" type="text" data-rules="{required:true}" class="input-normal control-text">
            </div>
          </div>
        </div>
        <div class="row">
          <div class="control-group span8">
            <label class="control-label"><s>*</s>分销价格：</label>
            <div class="controls">
              <input name="prodPrice" type="text" data-rules="{required:true}" class="input-normal control-text">
            </div>
          </div>
          <div class="control-group span8">
            <label class="control-label"><s>*</s>商品分类：</label>
            <div class="controls">
              <select data-rules="{required:true}" name="prodCategoryId" class="input-normal"> 
                <option value="">请选择</option>
                <#list productCategoryVOs as productCategoryVO>
					<option value="${productCategoryVO.productCategoryId}">${productCategoryVO.categoryName}</option>
				</#list>
              </select>
            </div>
          </div>
        </div>
      </form>
    </div>
</div>



  <script type="text/javascript">
    BUI.use('common/page');
  </script>
  <!-- 仅仅为了显示代码使用，不要在项目中引入使用-->
  <script type="text/javascript" src="/assets/js/prettify.js"></script>
  <script type="text/javascript">
    $(function () {
      prettyPrint();
    });
  </script> 
<script type="text/javascript">
  BUI.use('common/search',function (Search) {
    
    var enumObj = {"1":"男","0":"女"},
      editing = new BUI.Grid.Plugins.DialogEditing({
        contentId : 'content', //设置隐藏的Dialog内容
        autoSave : true, //添加数据或者修改数据时，自动保存
        triggerCls : 'btn-edit'
      }),
      columns = [
          {title:'商品编号',dataIndex:'prodId',width:150},
          {title:'品名规格',dataIndex:'prodName',width:200},
          {title:'商品型号',dataIndex:'prodModel',width:200},
          {title:'分销售价',dataIndex:'prodPrice',width:100},
          {title:'商品分类',dataIndex:'prodCategory',width:100},
          {title:'状态',dataIndex:'prodState',width:50},
          {title:'操作',dataIndex:'',width:200,renderer : function(value,obj){
            var passStr = '<span class="grid-command btn-open" title="审核通过">审核通过</span>',
              rejectStr = '<span class="grid-command btn-close" title="打回申请">打回申请</span>';
            return passStr + rejectStr;
          }}
        ],
      store = Search.createStore('/erpec/goods/control/ajaxGoodsCheckLst',{
        proxy : {
          save : { //也可以是一个字符串，那么增删改，都会往那么路径提交数据，同时附加参数saveType
            addUrl : '/erpec/goods/control/ajaxGoodsAdd',
            updateUrl : '/erpec/goods/control/ajaxGoodsEdt',
            removeUrl : '../data/del.php'
          },
          method : 'POST'
        },
        autoSync : true //保存数据后，自动更新
      }),
      gridCfg = Search.createGridCfg(columns,{
        tbar : {
          items : [
            {text : '<i class="icon-plus"></i>新建',btnCls : 'button button-small',handler:addFunction}
          ]
        },
        plugins : [editing,BUI.Grid.Plugins.CheckSelection,BUI.Grid.Plugins.AutoFit] // 插件形式引入多选表格
      });

    var search = new Search({
        store : store,
        gridCfg : gridCfg
      }),
      grid = search.get('grid');

    function addFunction(){
      var newData = {isNew : true}; //标志是新增加的记录
      editing.add(newData,'name'); //添加记录后，直接编辑
    }

    //删除操作
    function delFunction(){
      var selections = grid.getSelection();
      delItems(selections);
    }

    function delItems(items){
      var ids = [];
      BUI.each(items,function(item){
        ids.push(item.id);
      });

      if(ids.length){
        BUI.Message.Confirm('确认要删除选中的记录么？',function(){
          store.save('remove',{ids : ids});
        },'question');
      }
    }

    //监听事件，删除一条记录
    grid.on('cellclick',function(ev){
      var sender = $(ev.domTarget); //点击的Dom
      if(sender.hasClass('btn-del')){
        var record = ev.record;
        delItems([record]);
      }
    });
  });
</script>