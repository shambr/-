<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:import href="manage-layout.xslt"/>

<xsl:template name="head">
    <xsl:if test="$is_moderator">
        <script src="/js/jquery-ui.min.js"></script>
    </xsl:if>

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

<xsl:template match="content">
    <div>
        <xsl:variable name="current-filter1" select="/page/manifest/request/arguments/item[@name = 'filter1']"/>
        <form method="get()" class="filter" id="filterform">
            <select name="filter1" onchange="submit_filter()">
                <option value="all">
                    <xsl:if test="$current-filter1 = 'all'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Все вопросы</xsl:text>
                </option>
                <option value="notprocessed">
                    <xsl:if test="$current-filter1 = 'notprocessed'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Необработанные</xsl:text>
                </option>
                <option value="processed">
                    <xsl:if test="$current-filter1 = 'processed'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Обработанные</xsl:text>
                </option>
                <option value="notanswered">
                    <xsl:if test="$current-filter1 = 'notanswered'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Неотвеченные</xsl:text>
                </option>
                <option value="answered">
                    <xsl:if test="$current-filter1 = 'answered'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Отвеченные</xsl:text>
                </option>
                <option value="interesting">
                    <xsl:if test="$current-filter1 = 'interesting'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Интересные</xsl:text>
                </option>
                <option value="published">
                    <xsl:if test="$current-filter1 = 'published'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Опубликованные</xsl:text>
                </option>
                <option value="hidden">
                    <xsl:if test="$current-filter1 = 'hidden'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Скрытые</xsl:text>
                </option>
                <option value="removed">
                    <xsl:if test="$current-filter1 = 'removed'">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Удаленные</xsl:text>
                </option>
            </select>
            <input type="text" name="filter2"/>
        </form>
        <div class="filter-count">
            <xsl:value-of select="count(list/item)"/>
        </div>
        <div style="clear: both"/>
    </div>

    <script>
        function submit_filter() {
            document.getElementById('filterform').submit();
        }        
    </script>

    <xsl:apply-templates select="list"/>
</xsl:template>

<xsl:template match="content/list">
    <div class="list">
        <ul id="sortable">
            <xsl:apply-templates select="item"/>
        </ul>
    </div>

    <xsl:if test="$is_moderator">
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
                    <xsl:value-of select="@tags"/>                    
                </div>
                <div class="answers">
                    <img src="/i/answers.svg"/>
                    <xsl:if test="$is_moderator">
                        <xsl:text> </xsl:text>
                        <a href="/admin/invite?id={@id}" style="color: black; font-family: Arial; font-size: 80%">Пригласить ответить</a>
                        <xsl:text> </xsl:text>
                        <a href="/answers?id={@id}" style="color: black; font-family: Arial; font-size: 80%">                            
                            <xsl:variable name="answers-info" select="/page/content/answers-info/item[@question_id = current()/@id]"/>
                            <xsl:choose>
                                <xsl:when test="$answers-info">
                                    <xsl:value-of select="$answers-info/@count"/>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="$answers-info/@label"/>
                                </xsl:when>
                                <xsl:otherwise>Нет ответов</xsl:otherwise>
                            </xsl:choose>
                        </a>
                    </xsl:if>

                    <div class="buttons" id="buttons-{@id}" style="cursor:default">
                        <span style="position: relative; top: -1em; left: 0;">Проголосовать: </span>
                        <img src="/i/vote_minus.svg" onclick="vote({@id}, 'm')" style="cursor:pointer"/>
                        <img src="/i/vote_plus.svg" onclick="vote({@id}, 'p')" style="cursor:pointer"/>
                    </div>
                </div>

                <xsl:if test="$is_moderator">
                    <div class="moderation buttons">
                        <img src="/i/remove.svg" onclick="remove_question({@id})"/>
                        <br />
                        <img src="/i/edit.svg" onclick="document.location = '/edit?id={@id}'"/>
                    </div>
                </xsl:if>
            </div>
        </div>
    </li>
</xsl:template>

</xsl:stylesheet>
