<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<script>
  const login = {
    init:function(){
      $('#login_btn').click(()=>{
        this.send();
      });
    },
    check:function(){},
    send:function(){
      $('#login_form').attr('method','post');
      $('#login_form').attr('action','<c:url value="/loginimpl"/>');
      $('#login_form').submit();
    }
  }
  $(function(){
    login.init();
  });
</script>

<div class="col-sm-12">
  <h2>로그인을 해주세요!</h2>
  <div class="row">
    <div class="col-sm-6">
      <form id="login_form">
        <div class="form-group">
          <label for="id">아이디 입력:</label>
          <input type="text" value="1" name="id" class="form-control" placeholder="Enter id" id="id">
        </div>
        <div class="form-group">
          <label for="pwd">비밀번호 입력:</label>
          <input type="password" value="1" name="pwd" class="form-control" placeholder="Enter password" id="pwd">
        </div>
      </form>
      <button id="login_btn" class="btn btn-primary">로그인</button>
    </div>
    <div class="col-sm-6">
      <c:choose>
        <c:when test="${msg != null}">
          <h3>${msg}</h3>
        </c:when>
        <c:otherwise>
          <h3>로그인이 필요한 서비스입니다.</h3>
        </c:otherwise>
      </c:choose>
    </div>
  </div>

</div>