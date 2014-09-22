<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="layout.xslt"/>

<xsl:template name="head">
    <script src="/js/jquery-ui.min.js"></script>

    <script>
        function remove_question(question_id) {
            if (!confirm('Удалить вопрос?')) return;

            $.ajax({
                url: '/remove',
                type: 'get',
                data: {
                    id: question_id
                }
            }).done(function() {
                $('#card-' + question_id).hide('slow');
            });        
        }
    </script>    
</xsl:template>

<xsl:template match="content/list">
    <div class="list">
        <ul id="sortable">
            <xsl:apply-templates select="item"/>
        </ul>
    </div>

    <xsl:if test="/page/manifest/request/path = '/all'">
        <script>
            $("#sortable").sortable({
                beforeStop: function() {
                    var questions = $('div.questioncard');
                    var ids = '';
                    for (var c = 0; c != questions.length; c++) {
                        ids += questions[c].id + ',';
                    }
                    ids = ids.replace(/card-/g, '');
                    ids = ids.replace(/,$/, '');
                    
                    $.ajax({
                        url: '/sort',
                        type: 'get',
                        data: {
                            ids: ids
                        }
                    });
                }
            });    
        </script>
    </xsl:if>
</xsl:template>

<xsl:template match="content/list/item">
    <li>
        <a name="{@id}"/>
        <div class="questioncard" id="card-{@id}">
            <div class="name">
                <xsl:value-of select="@name"/>
            </div>
            <div class="questionblock c{position() mod 8}">
                <div class="score" id="score-{@id}">
                    <xsl:value-of select="@score"/>
                </div>
                <div class="text">
                    <xsl:if test="string-length(text()) &gt; 100">
                        <xsl:attribute name="class">text text1</xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="text()"/>
                </div>
                <div class="answers">
                    <img src="/i/answers.svg"/>
                </div>
                <div class="moderation buttons">
                    <img src="/i/remove.svg" onclick="remove_question({@id})"/>
                    <br />
                    <img src="/i/edit.svg" onclick="document.location = '/edit?id={@id}'"/>
                </div>
            </div>
        </div>
    </li>
</xsl:template>

<xsl:template name="menu">
    <div class="menu">
        <div class="menu-item">
            <xsl:choose>
                <xsl:when test="/page/manifest/request/path = '/all'">
                    <xsl:text>Публичные</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <a href="/all">Публичные</a>
                </xsl:otherwise>
            </xsl:choose>                        
        </div>
        <div class="menu-item">
            <xsl:choose>
                <xsl:when test="/page/manifest/request/path = '/allhidden'">
                    <xsl:text>Скрытые</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <a href="/allhidden">Скрытые</a>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </div>
</xsl:template>    

</xsl:stylesheet>
