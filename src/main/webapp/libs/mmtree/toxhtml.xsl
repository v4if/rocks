<?xml version="1.0" encoding="iso-8859-1"?>
<!--
Copyright (c) 2003 Miika Nurminen

Distributed under the terms of the MIT License.
See "LICENCE" or http://www.opensource.org/licenses/mit-license.php for details.

mmTree - alternate XHTML+Javascript export style sheet for FreeMind.

Miika Nurminen (minurmin@cc.jyu.fi) 12.12.2003.

Transforms Freemind (0.6.7 - 0.8.1) mm file to XHTML 1.1 with JavaScript-based 
keyboard navigation (MarkTree). Output is valid (possibly apart HTML entered 
by user in Freemind).

Updates:

2003-12-17 / MN
 - Support for mm 0.7.1 - 0.8.0 constructs (clouds, internal links. opens 
   internal link also if collapsed).
 - Support for icons. Some code adapted from Markus Brueckner's 
   freemind2html.xsl style sheet.
 - newlines &#xa;&#xa; behaviour (find and convert to <br/>)

2005-10-19 / MN
 - fixed some keyboard navigation bugs in marktree.js (see marktree 0.4 package 
   for more info)
 - added option to automatically "bold" node text for nodes that have children 
   (default:off to make it compatible with freemind default functionality) 

2006-03-11 / MN
 - now inserts correct path to xslt-stylesheet processing instruction
 - using Link.png for external links LinkLocal.png for local links 
   and ilink.png for arrows.
 - Note: img processing is awkward, because disable-output-escaping doesn't 
   seem to work with variables/params correctly. therefore a separate 
   link_start template is needed
 - http:// and end / are stripped away from link text when show_link_url=true
 - Supports clouds marked with default color (gray) and node background colors.
   Cloud rendering with rounded corners in mozilla-based browsers
 - Improved support for newlines
 - Html tags are stripped from title element
 
Todo:
 - Can CSS fonts be used with Freemind fonts?
 - Integrate JS file to stylesheet (is necessary?)
-->
<xsl:stylesheet version="1.0"
  xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  >
  <!-- mozilla doesn't parse method xhtml (in xslt 2.0) -->
  <xsl:output method="xml"
  version="1.0"
  encoding="iso-8859-1"
  doctype-public="-//W3C//DTD XHTML 1.1//EN"  
  doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
  omit-xml-declaration="no"
  />
  <!-- fc, 17.10.2004: The following parameter is set by freemind. -->
  <xsl:param name="destination_dir">./</xsl:param>

  <!-- if true, external links urls are shown, default false. -->
  <xsl:param name="show_link_url">false</xsl:param>

  <!-- if true, shows standard freemind icons (assumed to be in ./icons directory -->
  <xsl:param name="show_icons">true</xsl:param>

  <!-- if true, nodes with children are automatically bolded, default false -->
  <xsl:param name="bold_parents">false</xsl:param>

  <xsl:strip-space elements="*"/>
  <!-- note! nonempty links are required for opera! (tested with opera 7).
  #160 is non-breaking space.  / mn, 11.12.2003 
  --><xsl:template match="/">
    <xsl:processing-instruction name="xml-stylesheet">href="treestyles.css" type="text/css"</xsl:processing-instruction>
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fi" >
      <head>
<!--        <title><xsl:value-of select="/map/node/@TEXT"/>
        </title>-->
        <title>
            <xsl:for-each select="/map/node[1]">
                <xsl:variable name="temp"><xsl:call-template name="process-node-text" /></xsl:variable>
                <xsl:call-template name="strip_HTML">
                    <xsl:with-param name="value" select="$temp" />
                </xsl:call-template>
            </xsl:for-each>
        </title>
        <xsl:element name="link"><xsl:attribute name="rel">stylesheet</xsl:attribute>
        <xsl:attribute name="href"><xsl:value-of select="$destination_dir"/>treestyles.css</xsl:attribute>
        <xsl:attribute name="type">text/css</xsl:attribute></xsl:element>
        <xsl:element name="script"><xsl:attribute name="type">text/javascript</xsl:attribute>
        <xsl:attribute name="src"><xsl:value-of select="$destination_dir"/>marktree.js</xsl:attribute>&#160; </xsl:element>
      </head>
      <body>

        <div class="basetop">
          <a href="#" onclick="expandAll(document.getElementById('base'))">Expand</a> - <a href="#" onclick="collapseAll(document.getElementById('base'))">Collapse</a>
        </div>
        <div id="base" class="basetext">

<noscript>
<p style="border: solid #ff0000; padding: 1em;text-align:center"><b>Nodes cannot be expanded if JavaScript is disabled.<br /> Please enable JavaScript.</b></p>
</noscript>

          <ul>

            <xsl:apply-templates />

          </ul>
        </div>

      </body>
    </html>
  </xsl:template>

  <xsl:template name="strip_http">
      <xsl:param name="url" select="string('')" />
      <xsl:variable name="start"><xsl:choose>
          <xsl:when test="contains($url,'://')"><xsl:value-of select="substring-after($url,'://')" /></xsl:when>
          <xsl:otherwise><xsl:value-of select="$url" /></xsl:otherwise>
      </xsl:choose></xsl:variable>
      <xsl:choose>
      <xsl:when test="substring($start,string-length($start),1)='/'">
          <xsl:value-of select="substring($start,1,string-length($start)-1)" />
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="$start" /></xsl:otherwise>
      </xsl:choose>
  </xsl:template>
  
  <!-- line break handling -->
  <xsl:template name="format_text">
    <xsl:param name="nodetext" />
    <xsl:if test="string-length(substring-after($nodetext,'&#xa;')) = 0">
      <xsl:value-of select="$nodetext" />
    </xsl:if>
    <xsl:if test="string-length(substring-after($nodetext,'&#xa;')) &gt; 0">
      <xsl:value-of select="substring-before($nodetext,'&#xa;')" />
      <br />
      <xsl:call-template name="format_text">
        <xsl:with-param name="nodetext"><xsl:value-of select="substring-after($nodetext,'&#xa;')" /></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template match="font"><xsl:if test="string-length(@SIZE) &gt; 0">font-size:<xsl:value-of select="round((number(@SIZE) div 12)*100)" />%;</xsl:if><xsl:if test="@BOLD='true'">font-weight:bold;</xsl:if><xsl:if test="@ITALIC='true'">font-style:italic;</xsl:if></xsl:template>

<!-- &lt;body, not &lt;body&gt;, because freemind help file uses attributes in body tag -->
  <xsl:template name="html">
    <xsl:choose>
      <xsl:when test="(substring(@TEXT,string-length(@TEXT)-13,14)='&lt;/body&gt;&lt;/html&gt;') and 
        (substring(@TEXT,1,12)='&lt;html&gt;&lt;body&gt;')">
        <xsl:value-of select="substring(@TEXT,13,string-length(@TEXT)-26)"  disable-output-escaping="yes"/>
      </xsl:when>              
      <xsl:when test="contains(@TEXT,'&lt;body')">
          <xsl:variable name="temp" select="substring-after(substring-after(@TEXT,'&lt;body'),'&gt;')" />
          <xsl:value-of select="substring-before($temp,'&lt;/body&gt;')"  disable-output-escaping="yes" />
      </xsl:when>
      <xsl:when test="substring(@TEXT,string-length(@TEXT)-6,7)='&lt;/html&gt;'">
        <xsl:value-of select="substring(@TEXT,7,string-length(@TEXT)-13)"  disable-output-escaping="yes"/>
      </xsl:when>     
      <xsl:otherwise> 
        <xsl:value-of select="substring(@TEXT,7,string-length(@TEXT))"  disable-output-escaping="yes"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- note: </a> must be inserted manually! -->
  <xsl:template name="link">
      <xsl:param name="linktarget" select="string('')" />
      <xsl:param name="linkelement" select="/.." />
      <xsl:param name="inside" select="string('')" />
          <xsl:element name="a">
            <xsl:choose>
              <xsl:when test="substring($linkelement/@LINK,1,1)='#'">
                <xsl:attribute name="onclick">getVisibleParents('<xsl:value-of select="$linktarget" />');</xsl:attribute>
              <xsl:attribute name="href">#<xsl:value-of select="$linktarget" /></xsl:attribute>
              </xsl:when>
              <xsl:otherwise>
                <xsl:attribute name="href"><xsl:value-of select="$linktarget" /></xsl:attribute>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="$inside" />
          </xsl:element>
  </xsl:template>

  <xsl:template name="linkstart">
      <xsl:param name="linktarget" select="string('')" />
      <xsl:param name="linkelement" select="/.." />
      <xsl:text disable-output-escaping="yes">&lt;a </xsl:text>
            <xsl:choose>
              <xsl:when test="substring($linkelement/@LINK,1,1)='#'">
      onclick="getVisibleParents('<xsl:value-of select="$linktarget" />');"
      href="#<xsl:value-of select="$linktarget" />"
              </xsl:when>
              <xsl:otherwise>
      href="<xsl:value-of select="$linktarget" />"
              </xsl:otherwise>
            </xsl:choose><xsl:text disable-output-escaping="yes">&gt;</xsl:text>
  </xsl:template>
  
  
  <!-- FM prefix added for local links to get valid html -->
  <xsl:template name="spantext">
    <xsl:variable name="linktarget"><xsl:choose>
    <xsl:when test="(string-length(@LINK) &gt; 0) and (substring(@LINK,1,1)='#')">FM_<xsl:value-of select="substring(@LINK,2)" /></xsl:when>
    <xsl:otherwise><xsl:value-of select="@LINK" /></xsl:otherwise>
    </xsl:choose>
    </xsl:variable>
    
    <xsl:element name="span">
      <xsl:attribute name="style">
        <xsl:if test="(count(child::node)>0) and ($bold_parents='true')"> 
          font-weight:bold;
        </xsl:if>
        <xsl:if test="string-length(@COLOR) &gt; 0">color:<xsl:value-of select="@COLOR" />;
        </xsl:if>
        <xsl:apply-templates select="font" />
      </xsl:attribute>                    

      <xsl:choose>
        <xsl:when test="(string-length($linktarget) &gt; 0) and (($show_link_url='false'))">

        <xsl:call-template name="link">
            <xsl:with-param name="linktarget" select="$linktarget" />
            <xsl:with-param name="linkelement" select="." />
            <xsl:with-param name="inside">
                <xsl:call-template name="format_text">
                  <xsl:with-param name="nodetext"><xsl:value-of select="@TEXT" /></xsl:with-param>
                </xsl:call-template> 
            </xsl:with-param>
        </xsl:call-template>            
       
        <xsl:if test="$show_icons='true'">
        <xsl:text> </xsl:text>
            <xsl:call-template name="linkstart">
                <xsl:with-param name="linktarget" select="$linktarget" />
                <xsl:with-param name="linkelement" select="." />
            </xsl:call-template>            
            <xsl:text disable-output-escaping="yes">&lt;</xsl:text>img style="border-width:0" 
            <xsl:choose>
                <xsl:when test="(string-length(@LINK) &gt; 0) and (substring(@LINK,1,1)='#')">
                  src="<xsl:value-of select="$destination_dir"/>LinkLocal.png" 
                  alt="Local Link"
                </xsl:when>
                <xsl:otherwise>
                  src="<xsl:value-of select="$destination_dir"/>Link.png" 
                  alt="External Link"
                </xsl:otherwise>
            </xsl:choose>
            /<xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;/a&gt;</xsl:text>
        </xsl:if>
        
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="format_text">
            <xsl:with-param name="nodetext"><xsl:value-of select="@TEXT" /></xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>        
      </xsl:choose>
      
    </xsl:element>

    <xsl:if test="(string-length($linktarget) &gt; 0) and (($show_link_url='true'))">
    - [ <xsl:call-template name="link">
        <xsl:with-param name="linktarget" select="$linktarget" />
        <xsl:with-param name="linkelement" select="." />
        <xsl:with-param name="inside">
            <xsl:choose>
                <xsl:when test="substring(@LINK,1,1)='#'">local</xsl:when>
                <xsl:otherwise><xsl:call-template name="strip_http">
                  <xsl:with-param name="url" select="$linktarget" />
                </xsl:call-template></xsl:otherwise>
            </xsl:choose>
        </xsl:with-param>
       </xsl:call-template> ]
    </xsl:if>

    <xsl:if test="string-length(normalize-space(@TEXT)) = 0">
      <br /> 
    </xsl:if> <!-- anonymous node -->
    
  </xsl:template>
  

  <!-- assumes that context node is <node> -->
<xsl:template name="process-node-text">
      <xsl:choose>        
        <xsl:when test="substring(@TEXT,1,6)='&lt;html&gt;'">
          <xsl:call-template name="html" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="spantext" />
        </xsl:otherwise>
      </xsl:choose>
</xsl:template>

  <xsl:template match="node">
    <xsl:if test="count(child::node)=0"> 
      <xsl:call-template name="listnode">
        <xsl:with-param name="lifold">basic</xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="count(child::node)>0" > 
      <xsl:choose>
        <xsl:when test="@FOLDED='true'">
          <xsl:call-template name="listnode">
            <xsl:with-param name="lifold">exp</xsl:with-param>
            <xsl:with-param name="ulfold">sub</xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="listnode">
            <xsl:with-param name="lifold">col</xsl:with-param>
            <xsl:with-param name="ulfold">subexp</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>


  <xsl:template name="listnode">
    <xsl:param name="lifold" />
    <xsl:param name="ulfold" />
    <li class="{$lifold}">     

      <xsl:attribute name="style">
        <xsl:for-each select="cloud">
            <xsl:choose>
                <xsl:when test="string-length(@COLOR) &gt; 0">
                background-color:<xsl:value-of select="@COLOR" />;
                </xsl:when>
            <xsl:otherwise>
                background-color:#bbbbbb;
            </xsl:otherwise>
            </xsl:choose>
                border-color:#888888;
                border-width:thin;
                border-style:dotted;
                -moz-border-radius:5px;
                padding:5px;
        </xsl:for-each>
        <xsl:if test="@BACKGROUND_COLOR">
            background-color:<xsl:value-of select="@BACKGROUND_COLOR" />
        </xsl:if>
      </xsl:attribute>
      <!-- check if this node has an ID (for the document internal links) -->
      <xsl:if test="@ID">
        <!-- note: as FreeMind sometimes prepends the IDs with an underscore which is not valid
        as the first character in an HTML id, we surround the ID with FM<ID> -->
        
        <xsl:attribute name="id">FM<xsl:value-of select="@ID"/></xsl:attribute>
  
      </xsl:if>

      <xsl:if test="$show_icons='true'">
        <xsl:for-each select="icon">
          <xsl:element name="img">
            <xsl:attribute name="src"><xsl:value-of select="$destination_dir"/>icons/<xsl:value-of select="@BUILTIN" />.png</xsl:attribute>
            <xsl:attribute name="alt"><xsl:value-of select="@BUILTIN" /></xsl:attribute>
          </xsl:element>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </xsl:if> 
      
      <xsl:call-template name="process-node-text" />
      
      <xsl:if test="count(child::node)>0"> 
        <ul class="{$ulfold}"><xsl:apply-templates select="node"/></ul>
      </xsl:if>

      <!-- if there are arrowlinks inside this node (i.e. this node is connected to another node
      in FreeMind using an arrow), then create a document internal link -->
      <xsl:if test="count(child::arrowlink) &gt; 0">
        <xsl:if test="$show_icons='false'"> - [ </xsl:if>

        <xsl:for-each select="arrowlink">
          <xsl:text> </xsl:text> <a>
            <xsl:attribute name="onclick">getVisibleParents('FM<xsl:value-of select="@DESTINATION" />');</xsl:attribute>
            <xsl:attribute name="href">#FM<xsl:value-of select="@DESTINATION" /></xsl:attribute>
            <xsl:if test="$show_icons='true'">
              <xsl:element name="img">
                <xsl:attribute name="src"><xsl:value-of select="$destination_dir"/>LinkArrow.png</xsl:attribute>
                <xsl:attribute name="alt">Internal Arrowlink</xsl:attribute>
                <xsl:attribute name="style">border-width:0</xsl:attribute>
              </xsl:element>
            </xsl:if>
            <xsl:if test="$show_icons='false'"> link </xsl:if>
          </a>
        </xsl:for-each>
        <xsl:if test="$show_icons='false'"> ] </xsl:if>
      </xsl:if>
    </li>
  </xsl:template>

<!--
        strip_HTML
        removes all HTML from a given value (including tags that may be left open-ended when returned by the db)
        taken from: http://www.gotchas.info/xslt-to-strip-html/
-->
<xsl:template name="strip_HTML">
        <xsl:param name="value"/>
        <xsl:choose>
                <xsl:when test="contains($value,'&lt;')">
                        <xsl:value-of select="substring-before($value,'&lt;')" disable-output-escaping="yes"/>
                        <xsl:choose>
                                <xsl:when test="contains(substring-after($value,'&lt;'),'&gt;')">
                                        <xsl:call-template name="strip_HTML">
                                                <xsl:with-param name="value"><xsl:value-of select="substring-after($value,'&gt;')"/></xsl:with-param>
                                        </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                </xsl:otherwise>
                        </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                        <xsl:value-of select="$value" disable-output-escaping="yes"/>
                </xsl:otherwise>
        </xsl:choose>

</xsl:template>

  
</xsl:stylesheet>