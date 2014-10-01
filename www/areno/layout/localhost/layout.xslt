<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:variable name="user" select="/page/manifest/session"/>
<xsl:variable name="path" select="/page/manifest/request/path/text()"/>
<xsl:variable name="is_moderator" select="$user/@status = 'moderator'"/>

<xsl:template match="/page">
    <html>
        <head>
            <title>
                <xsl:call-template name="title"/>
            </title>
            <link rel="stylesheet" type="text/css" href="/i/main.css" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />
            <link href='http://fonts.googleapis.com/css?family=PT+Sans:400,700,400italic,700italic|Roboto+Condensed:400italic,700italic,400,700&amp;subset=latin,cyrillic-ext,cyrillic' rel='stylesheet' type='text/css'/>
            <script src="/js/jquery-1.11.1.min.js"></script>

            <xsl:call-template name="head"/>
        </head>
        <body>
            <xsl:call-template name="header"/>
            <div class="content">                
                <!--xsl:call-template name="menu"/-->
                <h1>
                    <xsl:call-template name="title"/>
                </h1>
                <xsl:apply-templates select="content"/>
            </div>
        </body>
    </html>
</xsl:template>

<xsl:template name="head"/>

<xsl:template name="title">
    <xsl:text>theQuestion</xsl:text>
</xsl:template>

<xsl:template name="header">
    <div class="header">
        <xsl:choose>
            <xsl:when test="$user/@status != 'user' and $user/@status != 'guest'">
                <span class="name">
                    <xsl:value-of select="$user/@firstname"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$user/@lastname"/>
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="$user/@status"/>
                    <xsl:text>)</xsl:text>
                </span>

                <span>
                    <a href="/logout">Выход</a>
                </span>
            </xsl:when>
            <xsl:otherwise>
                <span>
                    <xsl:choose>
                        <xsl:when test="$path = '/login'">
                            <xsl:text>Вход</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <a href="/login">Вход</a>
                        </xsl:otherwise>
                    </xsl:choose>
                </span>
            </xsl:otherwise>
        </xsl:choose>
            
        <span>
            <xsl:choose>
                <xsl:when test="$path = '/'">
                    <xsl:text>Вопросы</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <a href="/">Вопросы</a>
                </xsl:otherwise>
            </xsl:choose>
        </span>

        <span>
            <xsl:choose>
                <xsl:when test="$path = '/ask'">
                    <xsl:text>Спросить</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <a href="/ask">Спросить</a>
                </xsl:otherwise>
            </xsl:choose>
        </span>
        
        <xsl:if test="$is_moderator">
            <!--span>
                <xsl:choose>
                    <xsl:when test="$path = '/all'">
                        <xsl:text>Публичные</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <a href="/all">Публичные</a>
                    </xsl:otherwise>
                </xsl:choose>
            </span-->

            <span class="name">|</span>

            <span>
                <xsl:choose>
                    <xsl:when test="$path = '/allhidden'">
                        <xsl:text>Скрытые вопросы</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <a href="/allhidden">Скрытые вопросы</a>
                    </xsl:otherwise>
                </xsl:choose>
            </span>

            <span>
                <xsl:choose>
                    <xsl:when test="$path = '/admin/users'">
                        <xsl:text>Пользователи</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <a href="/admin/users">Пользователи</a>
                    </xsl:otherwise>
                </xsl:choose>
            </span>
        </xsl:if>
    </div>
</xsl:template>

<xsl:template name="menu">
    <div class="menu">
        <div class="menu-item">
            <xsl:choose>
                <xsl:when test="/page/manifest/request/path = '/'">
                    <xsl:text>Вопросы</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <a href="/">Вопросы</a>
                </xsl:otherwise>
            </xsl:choose>                        
        </div>
        <div class="menu-item">
            <xsl:choose>
                <xsl:when test="/page/manifest/request/path = '/ask'">
                    <xsl:text>Спросить</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <a href="/ask">Спросить</a>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </div>
</xsl:template>    

</xsl:stylesheet>
