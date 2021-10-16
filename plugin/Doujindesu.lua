-- import library

require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.GridLayout"
import "android.widget.*"
import "android.view.*"
import "android.graphics.drawable.ColorDrawable"
import "android.support.v4.widget.*"
import "android.graphics.Typeface"
import "android.graphics.drawable.PaintDrawable"
import "android.content.res.Configuration"
import "android.content.pm.ConfigurationInfo"
import "android.graphics.Paint"
import "android.view.WindowManager"
import "android.view.View"
import "java.io.File"
import "android.net.Uri"
import "android.net.Uri"
import "android.content.Intent"
import "android.content.pm.PackageManager"
import "android.graphics.BitmapFactory"
import "android.graphics.drawable.GradientDrawable"
import "android.view.View$OnSystemUiVisibilityChangeListener"
import "android.graphics.Bitmap"
import 'android.graphics.drawable.BitmapDrawable'
import "com.androlua.LuaWebView.*"
import "com.androlua.LuaWebView$LuaJavaScriptInterface"
import "java.net.*"
import "androlua.LuaHttp"
import "android.support.v7.widget.RecyclerView"
import "android.support.v7.widget.StaggeredGridLayoutManager"
import "android.support.v7.widget.LinearLayoutManager"
import "neo.hizuku.webtoon.NeoRecyclerAdapter"
import "neo.hizuku.webtoon.NeoRecyclerHolder"
import "neo.hizuku.webtoon.NekoAdapterCreator"
import "neo.hizuku.webtoon.ZoomableRecyclerView"
import "neo.hizuku.webtoon.ZoomableFrame"
import "neo.hizuku.webtoon.NeoLuaAdapter"
import "neo.hizuku.webtoon.NeoAdapterNeko"
import "android.graphics.drawable.ColorDrawable"
import "android.content.res.ColorStateList"
import "android.graphics.drawable.RippleDrawable"
import "android.view.animation.ScaleAnimation"
import "android.animation.AnimatorSet"
import "android.animation.ObjectAnimator"
import "android.animation.Animator"
import "android.view.animation.AccelerateInterpolator"
import "android.animation.ObjectAnimator"
import "android.view.animation.DecelerateInterpolator"
import "android.view.animation.AccelerateInterpolator"
import "android.graphics.Paint"
import "android.graphics.Color"
import "android.content.Context"
import "android.graphics.Rect"
import "org.jsoup.Jsoup"
import "cn.wanghaomiao.xpath.model.*"
import "com.bumptech.glide.Glide"
import "com.bumptech.glide.Priority"
import "com.bumptech.glide.load.engine.DiskCacheStrategy"
import "com.bumptech.glide.request.RequestListener"
import "com.bumptech.glide.request.animation.GlideAnimation"
import "com.bumptech.glide.request.target.Target"
import "com.bumptech.glide.request.target.ViewTarget"
import "com.bumptech.glide.load.model.GlideUrl"
import "com.bumptech.glide.load.model.LazyHeaders"
import "com.bumptech.glide.request.target.BitmapImageViewTarget"
import "androlua.widget.glide.LuaGlideModule"
import "android.animation.ObjectAnimator"
import "android.view.animation.DecelerateInterpolator"
import "android.content.res.ColorStateList"
import "android.graphics.drawable.RippleDrawable"
import "android.animation.PropertyValuesHolder"
import "android.view.animation.AccelerateInterpolator"
import "android.view.animation.OvershootInterpolator"
import "android.view.animation.AccelerateDecelerateInterpolator"
import "android.animation.AnimatorSet"
import "android.view.animation.BounceInterpolator"
import "android.content.res.Configuration"
import "android.view.animation.TranslateAnimation"
import "android.view.animation.AnimationUtils"
import "android.animation.AnimatorListenerAdapter"
import "android.animation.LayoutTransition"
import "android.graphics.Color"
import "android.text.Html"
import "android.graphics.Rect"
import "android.animation.ValueAnimator"
import "android.animation.ArgbEvaluator"
import "android.provider.Settings"
import "android.app.ActivityOptions"
import "android.util.Pair"
import "android.transition.Explode"
import "com.dingyi.dialog.BottomDialog"
import "com.etsy.android.grid.StaggeredGridView"
import "com.etsy.android.grid.util.DynamicHeightImageView"
import "com.etsy.android.grid.util.DynamicHeightTextView"
import "utils.RippleUtils"
import "utils.DecorViewUtils"
import "utils.Dp2MathUtils"
import "utils.GradientDrawableUtils"
import "utils.MyFontsUtils"
import "utils.ActivityUtils"
import "utils.AnimationUtils"
import "library.SnackedBar"
import "utils.ConnectErrr"
import "utils.JsoupUtils"
import "utils.PopupUtils"
import "library.MaterialButton"
import "library.MaterialChip"
import "library.MaterialScroll"
import "library.MaterialDialog"

require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "layout"
import "AndLua"
import "android.content.*"
import "android.net.*"
import "java.io.File"

activity.setContentView(loadlayout(layout))

layout=
{
  LinearLayout;
  orientation='vertical';--重力属性
  layout_width='fill';--布局宽度
  layout_height='fill';--布局高度
  background='';--布局背景颜色(或者图片路径)
  {
    CardView;--卡片控件
    --layout_margin='10dp';--卡片边距
    layout_gravity='center';--重力属性
    elevation='2dp';--阴影属性
    layout_width='90%w';--卡片宽度
    CardBackgroundColor='#ffffffff';--卡片背景颜色
    layout_height='60%w';--卡片高度
    radius='10dp';--卡片圆角
    {
      LinearLayout;
      orientation='vertical';--重力属性
      layout_width='fill';--布局宽度
      layout_height='fill';--布局高度
      background='';--布局背景颜色(或者图片路径)
      {
        LinearLayout;
        orientation='vertical';--重力属性
        layout_width='fill';--布局宽度
        --layout_height='50dp';--布局高度
        background='';--布局背景颜色(或者图片路径)

        {
          ImageView;
          id="imageView";
          layout_width='60dp';--布局宽度
          layout_height='60dp';--布局高度
        };
        {
          CardView;--卡片控件
          layout_margin='';--卡片边距
          --layout_gravity='center';--重力属性
          elevation='5dp';--阴影属性
          layout_width='fill';--卡片宽度
          CardBackgroundColor='#ff59c39b';--卡片背景颜色
          layout_height='50dp';--卡片高度
          radius='';--卡片圆角

          {
            TextView;--文本控件
            layout_width='fill';--文本宽度
            layout_height='fill';--文本高度
            gravity='center';--重力属性
            textColor='#ffffffff';--文字颜色
            text='发现更新';--显示的文字
            textSize='20dp';--文字大小
          };
        };

        {
          LinearLayout;
          layout_width="fill";
          layout_height="fill";
          orientation="vertical";
          {
            CardView;

            layout_height="20dp";
            id="button";
            layout_gravity="center";
            radius="28dp";
            CardElevation="4dp";
            layout_margin="16dp";
            layout_width="300dp";

            CardBackgroundColor='#ccccff';--卡片背景颜色
            --  background="#ccccff";
            --layout_height="60dp";
            {
              TextView;
              id="jv";
              background="#f100e5";
              layout_height="fill",
              --  layout_marginLeft='20dp',
              --  layout_marginRight='20dp',
              -- layout_marginTop='10dp',
            };
          },
          {
            TextView;
            text="";
            layout_width="fill";
            id="text";
          };
          {
            CardView;
            layout_height="40dp";
            id="bu";
            --layout_gravity="bottom|right";
            --radius="28dp";
            CardElevation="4dp";
            layout_marginLeft="16dp";
            layout_width="70dp";
            background="#3333ff";
            --Gravity='center';
            --layout_height="60dp";
            {
              CardView;
              layout_height="fill";
              layout_marginRight='2dp',
              layout_marginTop='2dp',
              layout_marginLeft="2dp";
              layout_marginBottom='2dp',
              layout_width="fill";
              background="#ffffff";
              {
                TextView;
                layout_gravity='center';
                --layout_margin="8dp";
                id="text2",
                text="下载",
                textSize='20dp';
                textColor='#3333ff';
                --layout_marginLeft='400',
                --layout_marginTop='10dp',
              };
            },
          },
        };
      };
    };
  };
};


dialog= AlertDialog.Builder(this)
dialog1=dialog.show()
dialog1.getWindow().setContentView(loadlayout(layout));
--dialog1.setCanceledOnTouchOutside(false)--设置点击阴影部分不会关闭公告
--dialog1.setCancelable(false)--设置点击返回键不会关闭公告
import "android.graphics.drawable.ColorDrawable"
dialog1.getWindow().setBackgroundDrawable(ColorDrawable(0x00000000));


--activity.setTitle('AndroLua+')
--activity.setTheme(android.R.style.Theme_Holo_Light)
--activity.setContentView(loadlayout(layout))

function xdc(url,path,路径)
  require "import"
  import "java.net.URL"
  import "android.graphics.BitmapFactory"
  import "java.io.BufferedInputStream"
  local ur = URL(url)
  import "java.io.File"
  file =File(path);
  con = ur.openConnection();
  co = con.getContentLength();
  is = con.getInputStream();
  bs = byte[1048576]
  local len,read=0,0
  len = is.read(bs)
  al=0 AS=0

  while len~=-1 do
    print(bmp)
    read=read+len
    pcall(call,"ding",read,co,len)
    al=al+1
    len = is.read(bs)
  end
  -- wj.close();
  is.close();
  pcall(call,"dstop",co,bmp)

end

function download(url,path,路径)
  a=thread(xdc,url,path,路径)
end

url="https://images2.imgbox.com/2f/8b/gxCBKwo1_o.jpg"

--设置保存目录和文件名
path="/storage/emulated/0/身份证号码"
路径="/storage/emulated/0/.text"
if 文件是否存在(路径) then
 else
  创建文件(路径)
end
--调用下载
--控件圆角(jv,0xFF02A9F4,30)
bu.onClick=function()
  if text2.Text=="下载" then
    download(url,path)
   elseif text2.Text=="安装" then
    --   activity.installApk(path)
   else

    退出页面()
    --  结束程序()
  end
end

--获取已下载及总长度
function ding(a,b,c)--已下载，总长度(byte)

  if a>=1024*1024 and a<=(1024*1024*1024)-1 then
    s=(a/1024)/1024
    s=string.format('%.2f', s).."mb"
   elseif a>=1024 and a<=(1024*1024)-1 then
    s=a/1024
    s=string.format('%.2f', s).."kb"
   elseif a<=1023 then
    s=string.format('%.2f', a).."k"
   elseif a>=1024*1024*1024 then
    s=a/(1024*1024*1024)
    s=string.format('%.2f', s).."G"
  end
  -- w=s
  if b>=1024*1024 and b<=(1024*1024*1024)-1 then
    ss=(b/1024)/1024
    ss=string.format('%.2f', ss).."mb"
   elseif b>=1024 and b<=(1024*1024)-1 then
    ss=b/1024
    ss=string.format('%.2f', ss).."kb"
   elseif b<=1023 then
    ss=string.format('%.2f', b).."k"
   elseif b>=1024*1024*1024 then
    ss=b/(1024*1024*1024)
    ss=string.format('%.2f', ss).."G"
  end

  print(a,b)
  
  jv.Width=965*(a/b)
  text.Text=s.."/"..ss
  text2.Text=string.format('%.2f',(a/b*100)).."%"
end

--下载完成后调用
function dstop(c,bmp)--总长度 
  imageView.setImageBitmap(bmp)
  text2.Text="安装"
end

plugin = {}
function plugin.getInfo()
end
return plugin
