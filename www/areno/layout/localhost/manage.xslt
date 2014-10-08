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
                $('#card2-' + question_id).hide('slow');
            });    
        }

        function toggle_interesting(question_id, value) {
            value = value ? 1 : 0;

            $.ajax({
                url: '/toggle_interesting',
                type: 'get',
                data: {
                    id: question_id,
                    v: value
                }
            }).done(function() {
                $('#text-' + question_id).animate({
                    color: (value ? "#3bdf6a" : "#e44d4d")
                }, 500).animate({
                    color: "#313131"
                }, 1000);
            });
        }

        function toggle_qstatus(question_id, status) {
            status = status == 'published' ? 1 : 0;

            $.ajax({
                url: '/toggle_qstatus',
                type: 'get',
                data: {
                    id: question_id,
                    v: status
                }
            }).done(function() {
                $('#text-' + question_id).animate({
                    color: (status ? "#3bdf6a" : "#e44d4d")
                }, 500).animate({
                    color: "#313131"
                }, 1000);
            });
        }

        function change_question_status(question_id) {
            var status = $('#qstatus-' + question_id).val();

            if (status == 'removed') {
                remove_question(question_id);
            }
            else {
                toggle_qstatus(question_id, status);
            }
        }

        function reload_filter() {
            $('#filterform').submit();
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
            <input type="text" name="filter2" id="filter2" placeholder="Поиск по тексту" value="{/page/manifest/request/arguments/item[@name = 'filter2']}"/>
            <span class="clear-field" onclick="$('#filter2').val(''); reload_filter();">×</span>

            <input type="text" name="filter3" id="filter3" placeholder="Поиск по тегам" value="{/page/manifest/request/arguments/item[@name = 'filter3']}"/>
            <span class="clear-field" onclick="$('#filter3').val(''); reload_filter();">×</span>

            <input type="submit" value="" style="visibility: hidden"/>
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
    <table class="questions">
        <thead>
            <tr>
                <th>Вопрос</th>
                <th>Дата и время</th>
                <th>Статус вопроса</th>
                <th>Рейтинг</th>
                <th>Ответов</th>
                <th>Статус ответа</th>
                <th>Время</th>
                <th>Ответственный</th>
            </tr>
        </thead>
        <tbody>
            <xsl:apply-templates select="item"/>
        </tbody>
    </table>
</xsl:template>

<xsl:template match="content/list/item">
    <tr id="card-{@id}">
        <td rowspan="2" class="info" style="width: 40%">
            <div>
                <xsl:value-of select="@name"/>
            </div>
            <div id="text-{@id}">
                <xsl:value-of select="@text"/>
                <xsl:if test="item">
                    <div class="tags">
                        <xsl:for-each select="item">
                            <a href="?filter1={/page/manifest/request/arguments/item[@name = 'filter1']/text()}&amp;filter2={/page/manifest/request/arguments/item[@name = 'filter2']/text()}&amp;filter3={text()}">
                                <xsl:value-of select="text()"/>
                            </a>
                        </xsl:for-each>
                    </div>
                </xsl:if>
            </div>
            <div class="actions">
                <label>
                    <input type="checkbox" onchange="toggle_interesting({@id}, this.checked)">
                        <xsl:if test="@is_interesting = 1">
                            <xsl:attribute name="checked">checked</xsl:attribute>
                        </xsl:if>
                    </input>
                    <xsl:text> Интересный</xsl:text>
                </label>

                <span>Ответить</span>
                <span>Найти эксперта</span>
                <span>Редактировать</span>
                <span onclick="remove_question({@id})">Удалить</span>                
            </div>
        </td>
        <td>
            <nobr>
                <xsl:value-of select="@datetime"/>
            </nobr>
        </td>
        <td>
            <select id="qstatus-{@id}" onchange="change_question_status('{@id}')">
                <option value="published">
                    <xsl:if test="@is_published = 1 and @is_removed = 0">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Опубликован</xsl:text>
                </option>
                <option value="hidden">
                    <xsl:if test="@is_published = 0 and @is_removed = 0">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Скрыт</xsl:text>
                </option>
                <option value="removed">
                    <xsl:if test="@is_removed = 1">
                        <xsl:attribute name="selected">selected</xsl:attribute>
                    </xsl:if>
                    <xsl:text>Удален</xsl:text>
                </option>
            </select>
        </td>
        <td>
            <xsl:value-of select="@score"/>
        </td>

        <td>
            <xsl:variable name="answers-info" select="/page/content/answers-info/item[@question_id = current()/@id]"/>
            <xsl:choose>
                <xsl:when test="$answers-info">
                    <xsl:value-of select="$answers-info/@count"/>
                </xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
        </td>
        <td>
        </td>
        <td>
        </td>
        <td>
        </td>
        <td rowspan="2" style="width: 1px;" class="info">
        </td>
    </tr>
    <tr class="info" id="card2-{@id}">
        <td colspan="4">
        </td>
        <td>
        </td>
        <td>
        </td>
        <td>
        </td>
    </tr>
</xsl:template>

</xsl:stylesheet>
