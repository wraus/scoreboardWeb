<!DOCTYPE html>
<!DOCTYPE html>

<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
    <head>
        <meta charset="UTF-8">
        <meta id="Viewport" name="viewport" width="initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no">
        <link rel="stylesheet" type="text/css" href="<c:url value='/css/scoreboard.css'/>" />
        <title>Cluden U14</title>
    </head>
    <body>
        <div id="wrapper">
            <div id="contentwrap">
                <div id="content">
                    <div><img src="<c:url value='/images/banner.jpg' />" class="banner"/></div>
                    <div class="container">
                        <div class="rows">
                            <div class="row">
                                <div class="column">
                                    <form action="<c:url value='/login' />" method="post">
                                        <c:if test="${param.error != null}">
                                            <div class="message">Invalid username and password.</div>
                                        </c:if>
                                        <c:if test="${param.logout != null}">
                                            <div class="message">You have been logged out.</div>
                                        </c:if>
                                        <fieldset class="inputFields">
                                            <div><label for="user">User Name :</label><input id="user" type="text" name="username"/></div>
                                            <div><label for="password">Password: </label><input id="password" type="password" name="password"/></div>
                                        </fieldset>
                                        <input type="hidden" name="${_csrf.parameterName}"
                                                    value="${_csrf.token}" />
                                        <div><button type="submit">Login</button> </div>
                                    </form:form >
                                </div>
                            </div>
                            <div class="row"/>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>