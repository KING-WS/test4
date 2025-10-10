<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="col-sm-9">
  <h2>Product Registration</h2>
  <form action="<c:url value="/map/registerimpl"/>" method="post" enctype="multipart/form-data">
    <div class="form-group">
      <label for="productName">Product Name:</label>
      <input type="text" class="form-control" placeholder="Enter product name" id="productName" name="productName">
    </div>
    <div class="form-group">
      <label for="productPrice">Price:</label>
      <input type="number" class="form-control" placeholder="Enter price" id="productPrice" name="productPrice">
    </div>
    <div class="form-group">
      <label for="discountRate">Discount Rate:</label>
      <input type="number" step="0.01" class="form-control" placeholder="Enter discount rate (e.g., 0.1 for 10%)" id="discountRate" name="discountRate">
    </div>
    <div class="form-group">
      <label for="lat">Latitude:</label>
      <input type="number" step="any" class="form-control" placeholder="Enter latitude" id="lat" name="lat">
    </div>
    <div class="form-group">
      <label for="lng">Longitude:</label>
      <input type="number" step="any" class="form-control" placeholder="Enter longitude" id="lng" name="lng">
    </div>
    <div class="form-group">
      <label for="description">Description:</label>
      <textarea class="form-control" placeholder="Enter description" id="description" name="description" rows="3"></textarea>
    </div>
    <div class="form-group">
      <label for="cateId">Category ID:</label>
      <input type="number" class="form-control" placeholder="Enter category ID" id="cateId" name="cateId">
    </div>
    <div class="form-group">
      <label for="pimg">Product Image:</label>
      <input type="file" class="form-control" placeholder="Select image" id="pimg" name="productImgFile">
    </div>
    <button type="submit" class="btn btn-primary">Register Product</button>
  </form>

</div>