<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="layout.xslt"/>

<xsl:template name="head">
    <xsl:call-template name="facebook-sdk"/>
</xsl:template>


<xsl:template match="content/login">
    <div class="whitecontent">
        <h3><label><input type="radio" name="logintype" onclick="loginform(1)"/> Логин через Фейсбук</label></h3>
        <h3 style="margin-top: 0"><label><input type="radio" name="logintype" checked="checked" onclick="loginform(2)"/> Логин с паролем</label></h3>

        <div id="FBLogin" class="hidden">
            <xsl:call-template name="fb-form"/>
        </div>
        <form method="post" id="UsernameLogin">
            <h3>Ваши имя пользователя и пароль:</h3>
            <div>
                <input class="text" type="text" name="username" value="{/page/manifest/username}"/>
            </div>
            <br/>
            <div>
                <input class="text" type="password" name="password"/>
            </div>
            <br/>
            <div class="submit">
                <input class="wide" type="submit" value="ВОЙТИ"/>
            </div>
        </form>
    </div>
    <script>
        function loginform(v) {
            if (v == 1) {
                $('#FBLogin').show();
                $('#UsernameLogin').hide();
            }
            else {
                $('#FBLogin').hide();
                $('#UsernameLogin').show();            
            }
        }
    </script>
</xsl:template>

<xsl:template match="content/error">
    <p class="error">
        <xsl:value-of select="text()"/>
    </p>
</xsl:template>

<xsl:template name="facebook-sdk">
    <script>
      // This is called with the results from from FB.getLoginStatus().
      function statusChangeCallback(response) {
        console.log('statusChangeCallback');
        console.log(response);
        // The response object is returned with a status field that lets the
        // app know the current login status of the person.
        // Full docs on the response object can be found in the documentation
        // for FB.getLoginStatus().        
        if (response.status === 'connected') {
          // Logged into your app and Facebook.
          testAPI();
        } else if (response.status === 'not_authorized') {
          // The person is logged into Facebook, but not your app.
          document.getElementById('status').innerHTML = 'Please log ' +
            'into this app.';
        } else {
          // The person is not logged into Facebook, so we're not sure if
          // they are logged into this app or not.
          document.getElementById('status').innerHTML = 'Please log ' +
            'into Facebook.';
        }
      }

      // This function is called when someone finishes with the Login
      // Button.  See the onlogin handler attached to it in the sample
      // code below.
      function checkLoginState() {
        FB.getLoginStatus(function(response) {
          statusChangeCallback(response);
        });
      }

      window.fbAsyncInit = function() {
          FB.init({
            appId      : '657734457675987',
            cookie     : true,  // enable cookies to allow the server to access 
                                // the session
            xfbml      : true,  // parse social plugins on this page
            version    : 'v2.1' // use version 2.1
          });

          // Now that we've initialized the JavaScript SDK, we call 
          // FB.getLoginStatus().  This function gets the state of the
          // person visiting this page and can return one of three states to
          // the callback you provide.  They can be:
          //
          // 1. Logged into your app ('connected')
          // 2. Logged into Facebook, but not your app ('not_authorized')
          // 3. Not logged into Facebook and can't tell if they are logged into
          //    your app or not.
          //
          // These three cases are handled in the callback function.

          FB.getLoginStatus(function(response) {
            statusChangeCallback(response);
          });

      };

      // Load the SDK asynchronously
      (function(d, s, id) {
        var js, fjs = d.getElementsByTagName(s)[0];
        if (d.getElementById(id)) return;
        js = d.createElement(s); js.id = id;
        js.src = "//connect.facebook.net/en_US/sdk.js";
        fjs.parentNode.insertBefore(js, fjs);
      }(document, 'script', 'facebook-jssdk'));

      // Here we run a very simple test of the Graph API after login is
      // successful.  See statusChangeCallback() for when this call is made.
      function testAPI() {
        FB.api('/me', function(response) {  
          document.getElementById('status').innerHTML =
            'Thanks for logging in, ' + response.name + '!';
        });
      }
    </script>
</xsl:template>

<xsl:template name="fb-form">    
    <fb:login-button xmlns:fb="http://facebook.com/" scope="public_profile,email" onlogin="checkLoginState();">
    </fb:login-button>
    <div id="status"></div>
</xsl:template>    

</xsl:stylesheet>
