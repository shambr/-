<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="layout.xslt"/>

<xsl:template name="head">
    <script>
        var questionPosted = 0;

        function postQuestion() {
            return $('#Question').val().length != 0;
        }

        function startTyping() {
            if (questionPosted) {
                $('#Message').fadeOut(1000);
            }

            questionPosted = 0;

            if ($('#Question').val().replace(/^[ \\n\\t]+/, '').replace(/[ \\n\\t]+\$/, '').length != 0) {
                $('#Submit').addClass("enabled");
                $('#Submit').removeClass("disabled");
            }
            else {
                $('#Submit').addClass("disabled");
                $('#Submit').removeClass("enabled");
            }
        }

        function clear_form() {
            $('#Question').val('');
            $('#Tags').val('');
        }
    </script>
</xsl:template>

<xsl:template match="content/ask">
    <p class="subhead">Мы верим в&#160;тех, кто задает вопросы</p>

    <div class="whitecontent">
        <div id="Info">
            <p>Когда у&#160;вас появляется вопрос, на&#160;который нигде нет ответа, задайте его нам. Мы&#160;найдем тех, кто знает, разберется и&#160;ответит. Нам кажется, что многим было&#160;бы интересно прочитать о&#160;том, что вы&#160;спросили и&#160;как вам ответили. Сейчас мы&#160;собираем ваши вопросы, чтобы подготовиться к&#160;запуску сайта.</p>            
        </div>

        <form method="post" action="/post" enctype="multipart/form-data" id="PostForm" onsubmit="return postQuestion();">
            <h3 id="QLabel">Какой вопрос вы хотите задать?</h3>
            <textarea id="Question" name="question" placeholder="" onkeypress="startTyping();" onclick="startTyping();"></textarea>

            <h3>Теги, чтобы найти вопрос:</h3>
            <input id="Tags" class="text" type="text" name="tags" placeholder="" autocapitalize="off" />

            <h3>Как вас зовут?</h3>
            <input id="Name" class="text" type="text" name="name" placeholder="" value="{/page/manifest/request/cookies/item[@name = 'name']}" />

            <p style="margin-top: 4em;">Мы&#160;найдем и&#160;опубликуем ответы на&#160;заданные вопросы. Оставьте, пожалуйста, свой e-mail; когда ответы будут готовы, мы&#160;напишем&#160;вам.</p>
            <h3 style="margin-top: 0">Ваш e-mail:</h3>
            <input id="Email" class="text" type="email" name="email" placeholder="" value="{/page/manifest/request/cookies/item[@name = 'email']}" autocapitalize="off" />

            <div class="submit">
                <input name="submit" id="Submit" class="disabled" type="submit" value="Отправить вопрос" />
            </div>
        </form>
    </div>
</xsl:template>

</xsl:stylesheet>
