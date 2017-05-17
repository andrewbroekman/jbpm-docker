<xsl:stylesheet version="2.0"
                xpath-default-namespace="http://java.sun.com/xml/ns/javaee"
                xmlns="http://java.sun.com/xml/ns/javaee"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="//web-app/filter[filter-name[text()='HTTP Basic Auth Filter']]"/>
    <xsl:template match="//web-app/filter-mapping[filter-name[text()='HTTP Basic Auth Filter']]"/>

    <xsl:template match="//web-app/security-constraint[1]">
      <xsl:copy-of select="."/>
        <security-constraint>
            <web-resource-collection>
                <web-resource-name>remote-services</web-resource-name>
                <url-pattern>/rest/*</url-pattern>
                <url-pattern>/maven2/*</url-pattern>
                <url-pattern>/ws/*</url-pattern>
            </web-resource-collection>
            <auth-constraint>
                <role-name>rest-all</role-name>
            </auth-constraint>
        </security-constraint>
    </xsl:template> 

    <xsl:template match="//session-config/session-timeout">
        <session-timeout>30</session-timeout>
    </xsl:template> 

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
