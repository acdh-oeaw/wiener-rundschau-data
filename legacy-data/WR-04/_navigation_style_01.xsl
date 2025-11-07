<?xml version='1.0'?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  version="1.0">

  <xsl:output method="html" encoding="utf-8"/>
  <xsl:variable name="offsetTop" select="30"/>
  <xsl:variable name="recWidth" select="25"/>
  <xsl:variable name="entryNum" select="count(//file)"/>
  <xsl:variable name="maxRow" select="(//file/row)[last()]"/>
  <xsl:variable name="rowMargin" select="5"/>

  <xsl:template match="/">

    <html>
      <head>
        <script language="Javascript1.2">
          var scrollMem = 0;
          var bodyDone = 0;
          var actID = -1;
          var oldZIndex = -1;
          var commLock = false;
          var messageCnt = 0;
          var titleMem = '';

          function initFrame2(auth_, title_, subtitle_, edition_, imprdate_) {
            
            if (bodyDone == 0) {
              if (auth_ == 'Missing author data ...') { auth_ = '--';}
              if (edition_ == 'Missing edition data ...') { edition_ = '';}
              sh = '<html>'+
              '<head>'+
              '<style type="text/css">'+
                '.clSubTitle {'+
                  'border:1px solid color:rgb(69,76,76);'+
                  'padding-left:20px;'+
                  'color:rgb(69,76,76);'+
                  'font-size:13pt;'+
                  'font-family:Arial;'+
                '}'+
                '.clImprDate {'+
                  'border:1px solid color:rgb(69,76,76);'+
                  'padding-left:20px;color:rgb(69,76,76);'+
                  'color:rgb(69,76,76);'+
                  'font-size:13pt;'+
                  'font-family:Arial;'+
                '}'+
              '</style>'+
              '</head>'+
              '<body style="background:rgb(205,215,215);">'+
              '<table class="tbMetaData">'+
              '<tr><td class="clAuth" id="pAuthor">' + auth_ + '</td></tr>'+
              '<tr><td class="clTitle" id="pTitle">' + title_ + '</td></tr>'+
              '<tr><td class="clSubTitle">' + subtitle_ + ' ' + edition_ + '</td></tr>'+
              '<tr><td class="clImprDate">' + imprdate_ + '</td></tr>'+
              '<tr><td class="clImprDate" id="pPage">&#xA0;</td></tr>'+
              '<tr><td id="pFN">&#xA0;</td></tr>'+
              '<tr><td id="pTitles">&#xA0;</td></tr>'+
              '</table>'+
              '</body></html>';
              /*parent.frame2.document.write(sh);*/
              document.location = 'catch_:' + sh;
              bodyDone = 1;
            }
          }
          
      
          function dbg(s_) {
            /*
            messageCnt++;
            pobj = document.getElementById('pdebug');
            if (pobj) {
              pobj.innerHTML = messageCnt + ': ' + s_ + '<br/>' + pobj.innerHTML;
            }
            */
          }
          
          function returnData(title_, fn_, pn_, th_) {
            if (commLock == false) {
              th_.style.cursor = 'pointer';
              commLock = true;
              ar = title_.split(',');
              titles = '';
              i = 0;
              while (i != ar.length) {
                titleID = 'pTitle' + ar[i];
                textObj = document.getElementById(titleID);
            
                if (textObj) {
                  titles = titles + '<li>' + textObj.innerHTML + '</li>';
                }
            
                i++;
              }

              document.location = 'catchTitle_:' + titles + '__fn:' + fn_ + '__pn:' + pn_;
              commLock = false;
            }
          }
          
          function retrFile(fn_) {
            document.location = 'retrieve:' + fn_;
            window.event.cancelBubble = true; 
            commLock = false;
            window.event.returnValue = false;
          }
        </script>
        
        <style type="text/css">
          body {
            scrollbar-face-color:rgb(231,240,240);
            scrollbar-arrow-color:rgb(136,156,162)
            scrollbar-base-color:rgb(231,240,240);
            scrollbar-shadow-color:white;
            scrollbar-darkshadow-color:rgb(231,240,240);
            scrollbar-highlight-color:white;
            scrollbar-3dlight-color:rgb(136,156,162);
            scrollbar-track-color:rgb(205,215,215);
            background: white;
          }
          
          table {
            border-collapse: collapse;
          }
          
          td {
            border: 0px solid black;
            border-collapse: collapse;
            text-align:right;
            vertical-align: bottom;
          }
          
          span.titleT {
            font-size:6pt;
            font-family:Arial;
            color:white;
            background:rgb(0,0,120)
            padding-left:1px;
            padding-right:1px;
          }
          
          span.contC {
            font-size:6pt;
            font-family:Arial;
            color:white;
            background:rgb(0,120,0)
            padding-left:1px;
            padding-right:1px;
          }
          
          span.imgI {
            font-size:6pt;
            font-family:Arial;
            color:white;
            background:rgb(120,0,0)
            padding-left:1px;
            padding-right:1px;
          }
          
          td.pageTop {
            text-align:left;
            vertical-align: top;
          }
          
          td.tdAuthor {
            border: 1px solid black;
            border-collapse: collapse;
            text-align:left;
            vertical-align: top;
            font-weight:bold;
            font-size:14pt;
            background:rgb(231,240,240);
          }
          td.tdTitle {
            border: 1px solid black;
            border-collapse: collapse;
            text-align:left;
            vertical-align: top;
            font-weight:bold;
            font-size:14pt;
            background:rgb(231,240,240);
          }
          td.tdTop {
            border-top: 1px solid black;
            border-left: 0px;
            width:100px;
          }
        </style>
      </head>
    
      <body>
        <script language="Javascript1.2">
          initFrame2('<xsl:value-of select="//author"/>', '<xsl:value-of select="//title"/>', '<xsl:value-of select="//subTitle"/>', '<xsl:value-of select="//edition"/>', '<xsl:value-of select="//imprDate"/>');
        </script>
        
        <p id="pdebug" style="position:absolute:left:10px;top:10px;z-index:3;">
          
        </p>
        
        <xsl:for-each select="//file">
          <xsl:sort select="id" order="descending"/>
          <xsl:variable name="sid" select="count(preceding::file)"/>
          
          <xsl:variable name="titleNum" select="count(fileDesc/TITLE)"/>
          <xsl:variable name="tableStyle">
            border: 1px solid rgb(30,30,30);
            position:absolute;
            left:<xsl:value-of select="(col*$recWidth)-(col*$rowMargin)"/>px;
            top:<xsl:value-of select="(row*$recWidth)+(row*$rowMargin) + $offsetTop - (col*2)"/>px;
            width:<xsl:value-of select="($recWidth)"/>px;
            height:<xsl:value-of select="($recWidth)"/>px;
            font-size:6pt;
            z-index:<xsl:value-of select="$entryNum - count(preceding::file)"/>;
            background:rgb(<xsl:value-of select="200+(col*5)"/>,<xsl:value-of select="210+(col*5)"/>,<xsl:value-of select="210+(col*5)"/>);
          </xsl:variable>
          
          <table>
            <xsl:attribute name="id"><xsl:value-of select="$sid"/></xsl:attribute>
            <xsl:variable name="paramString">
              <xsl:for-each select="fileDesc/TITLE"><xsl:if test="position()&gt;1">,</xsl:if><xsl:value-of select="count(preceding::TITLE)"/></xsl:for-each>
            </xsl:variable>
            <xsl:variable name="onMouseMoveString">
              returnData('<xsl:choose><xsl:when test="string-length($paramString)&gt;0"><xsl:value-of select="$paramString"/></xsl:when>
              </xsl:choose>', '<xsl:value-of select="fileName"/>', '<xsl:value-of select="pn"/>', this);
              
            </xsl:variable>
            <xsl:attribute name="style"><xsl:value-of select="normalize-space($tableStyle)"/></xsl:attribute>

            <tr><td class="pageTop">
              <xsl:attribute name="onClick">javascript:void(0);</xsl:attribute>
              <xsl:attribute name="onMouseDown">retrFile('<xsl:value-of select="fileName"/>');</xsl:attribute>
              <xsl:attribute name="onMouseOver"><xsl:value-of select="normalize-space($onMouseMoveString)"/></xsl:attribute>

              <xsl:if test="$titleNum&gt;0"><span class="titleT">T</span></xsl:if>
              <xsl:if test="fileDesc/isContents"><span class="contC">C</span></xsl:if>
              <xsl:if test="fileDesc/hasImage"><span class="imgI">I</span></xsl:if>
              &#xA0;</td></tr><xsl:text>&#x0D;&#x0A;</xsl:text>
              
            <tr><td>
            
              <xsl:attribute name="onClick">javascript:void(0);</xsl:attribute>
              <xsl:attribute name="onDblClick">dbg('dbl on td <xsl:value-of select="position()"/>');</xsl:attribute>
              <xsl:attribute name="onMouseDown">retrFile('<xsl:value-of select="fileName"/>');</xsl:attribute>
              <xsl:attribute name="onMouseOver"><xsl:value-of select="normalize-space($onMouseMoveString)"/></xsl:attribute>

              <xsl:if test="fileType='n'"><xsl:value-of select="pn"/></xsl:if>
             </td></tr>
             
             
          </table>
          
        </xsl:for-each>
        
        <xsl:for-each select="//TITLE">
          <span style="position:absolute;left:-100px;top:-1000px;">
            <xsl:attribute name="id">pTitle<xsl:value-of select="count(preceding::TITLE)"/></xsl:attribute>
            <xsl:apply-templates/>
          </span>
        </xsl:for-each>

        <p>
          <xsl:attribute name="style">
            position:absolute;
            left:20px;
            top:<xsl:value-of select="($maxRow*$recWidth)+($maxRow*$rowMargin) + $offsetTop + 50"/>px;
          </xsl:attribute>&#xA0;
        </p>
        
      </body>
    </html>
    
  </xsl:template>
  

</xsl:stylesheet>
