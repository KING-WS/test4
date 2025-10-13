<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="container-fluid">
    <h1 class="h3 mb-2 text-gray-800">신고 내역</h1>
    <div class="card shadow mb-4">
        <div class="card-header py-3">
            <h6 class="m-0 font-weight-bold text-primary">신고 목록</h6>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-bordered" id="dataTable" width="100%" cellspacing="0">
                    <thead>
                        <tr>
                            <th>신고 ID</th>
                            <th>신고자 ID</th>
                            <th>피신고자 ID</th>
                            <th>신고 내용</th>
                            <th>신고 날짜</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${report}" var="r">
                            <tr>
                                <td>${r.reportId}</td>
                                <td><a href="/cust/detail?id=${r.reporterId}">${r.reporterId}</a></td>
                                <td><a href="/cust/detail?id=${r.reportedId}">${r.reportedId}</a></td>
                                <td>${r.reportContent}</td>
                                <td>${r.reportDate}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>