<!DOCTYPE html>
<%@taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="req" value="${pageContext.request}" />
<c:set var="url">${req.requestURL}</c:set>
<c:set var="uri" value="${req.requestURI}" />
<html lang="en">
<head>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/bootstrap.min.css'/>" />
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/jquery.countdown.css'/>" />

    <script src="<c:url value='/scripts/jquery-2.1.4.js'/>"></script>
    <script src="<c:url value='/scripts/jquery.plugin.js'/>"></script>
    <script src="<c:url value='/scripts/jquery.countdown.js'/>"></script>
    <c:set var="home">${fn:substring(url, 0, fn:length(url) - fn:length(uri))}${req.contextPath}/</c:set>
</head>

<nav class="navbar navbar-inverse">
    <div class="container">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">Wheelchair Rugby Controller</a>
        </div>
    </div>
</nav>

<div class="container" style="min-height: 500px">

    <div class="starter-template">
        <h1>Score Controller</h1>
        <br>

        <form class="form-horizontal" id="score-manager">
            <div class="form-group form-group-lg">
                <label class="col-sm-2 control-label">Home Team Name</label>
                <div class="col-sm-10">
                    <input type=text class="form-control" id="team1Name">
                </div>
            </div>
            <div class="form-group form-group-lg">
                <label class="col-sm-2 control-label">Away Team Name</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="team2Name">
                </div>
            </div>

            <div class="form-group form-group-lg">
                <label class="col-sm-2 control-label">Home Team Score</label>
                <div class="col-sm-10">
                    <input type=text class="form-control" id="team1Score">
                </div>
            </div>
            <div class="form-group form-group-lg">
                <label class="col-sm-2 control-label">Away Team Score</label>
                <div class="col-sm-10">
                    <input type="text" class="form-control" id="team2Score">
                </div>
            </div><div class="form-group form-group-lg">
                <label class="col-sm-2 control-label">Game Clock</label>
                <div class="col-sm-10">
                    <span id="clock"></span>
                </div>
            </div>


            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <button type="submit" id="bth-search"
                            class="btn btn-primary btn-lg">Start</button>
                </div>
            </div>
        </form>

    </div>

</div>

<div class="container">
    <footer>
        <p>
            Sponsored by <a href="http://http://auspost.com.au/">Australia Post</a>
        </p>
    </footer>
</div>

<script>
    var eightMinsLater = new Date();
    eightMinsLater.setMinutes(eightMinsLater.getMinutes() + 8);
    $('#clock').countdown({until: eightMinsLater, format: 'MS'});

    jQuery(document).ready(function($) {

        $("#score-manager").submit(function(event) {

            // Prevent the form from submitting via the browser.
            event.preventDefault();

            submitViaAjax();

        });

    });

    function submitViaAjax() {

        var score = {}
        score["team1Name"] = $("#team1Name").val();
        score["team2Name"] = $("#team2Name").val();
        score["team1Score"] = $("#team1Score").val();
        score["team2Score"] = $("#team2Score").val();

        $.ajax({
            type : "POST",
            contentType : "application/json",
            url : "${home}/score",
            data : JSON.stringify(score),
            dataType : 'json',
            timeout : 100000,
            success : function(data) {
                console.log("SUCCESS: ", data);
                display(data);
            },
            error : function(e) {
                console.log("ERROR: ", e);
                display(e);
            },

        });

    }

</script>

</body>
</html>