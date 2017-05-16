<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="2.0"
                xpath-default-namespace="urn:jboss:domain:4.2"
                xmlns="urn:jboss:domain:4.2"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:ds="urn:jboss:domain:datasources:4.0"
                xmlns:sec="urn:jboss:domain:security:1.2"
                xmlns:ut="urn:jboss:domain:undertow:3.1"
                xmlns:jboss="urn:jboss:domain:4.2"
                exclude-result-prefixes="ds sec ut jboss #default">

    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="//system-properties">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="node()|@*"/>
            <property name="org.kie.server.persistence.dialect" value="org.hibernate.dialect.MySQLDialect"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//ds:subsystem/ds:datasources/ds:datasource[@jndi-name='java:jboss/datasources/ExampleDS']" xmlns="urn:jboss:domain:datasources:4.0">
        <datasource jndi-name="java:jboss/datasources/ExampleDS" pool-name="ExampleDS" jta="true" enabled="true" use-java-context="true" use-ccm="true">
            <connection-url>jdbc:mysql://${env.MYSQL_HOST}:${env.MYSQL_PORT}/${env.MYSQL_DATABASE:jbpm}</connection-url>
            <driver>mysql</driver>
            <security>
                <user-name>${env.MYSQL_USERNAME:jbpm}</user-name>
                <password>${env.MYSQL_PASSWORD:password}</password>
            </security>
            <validation>
                <check-valid-connection-sql>SELECT 1</check-valid-connection-sql>
                <background-validation>true</background-validation>
                <background-validation-millis>60000</background-validation-millis>
            </validation>
            <pool>
                <flush-strategy>IdleConnections</flush-strategy>
            </pool>
        </datasource>
    </xsl:template>

    <xsl:template match="//ds:subsystem/ds:datasources/ds:drivers" xmlns="urn:jboss:domain:datasources:4.0">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
            <driver name="mysql" module="com.mysql">
                <xa-datasource-class>com.mysql.jdbc.jdbc2.optional.MysqlXADataSource</xa-datasource-class>
            </driver>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//extensions">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
            <extension module="org.keycloak.keycloak-adapter-subsystem"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//sec:subsystem/sec:security-domains/sec:security-domain[@name='other']" xmlns="urn:jboss:domain:security:1.2">
        <security-domain name="other" cache-type="default">
            <authentication>
                <login-module code="org.keycloak.adapters.jaas.DirectAccessGrantsLoginModule" flag="required">
                    <module-option name="keycloak-config-file" value="/opt/jboss/wildfly/standalone/configuration/kie-git.json"/>
                </login-module>
            </authentication>
        </security-domain>
    </xsl:template>

    <xsl:template match="//sec:subsystem/sec:security-domains" xmlns="urn:jboss:domain:security:1.2">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
            <security-domain name="keycloak" cache-type="default">
                <authentication>
                    <login-module code="org.keycloak.adapters.jboss.KeycloakLoginModule" flag="required"/>
                </authentication>
            </security-domain>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="//ut:subsystem/ut:server[@name='default-server']" xmlns="urn:jboss:domain:undertow:3.1">
        <server name="default-server">
            <http-listener name="default" socket-binding="http"/>
            <host name="default-host" alias="localhost">
                <location name="/" handler="welcome-content"/>
                <filter-ref name="server-header"/>
                <filter-ref name="x-powered-by-header"/>
                <single-sign-on/>
            </host>
        </server>
    </xsl:template>

    <xsl:template match="//server/profile">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
                <subsystem xmlns="urn:jboss:domain:keycloak:1.1">
                    <secure-deployment name="kie-wb.war">
                        <realm>${env.KC_REALM}</realm>
                        <resource>kie</resource>
                        <enable-basic-auth>true</enable-basic-auth>
                        <auth-server-url>${env.KC_BASE_URL}</auth-server-url>
                        <ssl-required>external</ssl-required>
                        <principal-attribute>preferred_username</principal-attribute>
                        <credential name="secret">${env.KC_KIE_SECRET}</credential>
                    </secure-deployment>
                    <secure-deployment name="kie-server.war">
                        <realm>${env.KC_REALM}</realm>
                        <resource>kie-execution-server</resource>
                        <enable-basic-auth>true</enable-basic-auth>
                        <auth-server-url>${env.KC_BASE_URL}</auth-server-url>
                        <ssl-required>external</ssl-required>
                        <principal-attribute>preferred_username</principal-attribute>
                        <credential name="secret">${env.KC_KIE_EXECUTION_SERVER_SECRET}</credential>
                    </secure-deployment>
                </subsystem>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
