document.addEventListener("DOMContentLoaded", function() {
  var input = document.getElementById("product_image");
  var nameSpan = document.getElementById("selected-image-name");
  if(input && nameSpan) {
    input.addEventListener("change", function() {
      if (input.files && input.files[0]) {
        nameSpan.textContent = input.files[0].name;
      } else {
        nameSpan.textContent = "";
      }
    });
  }
}); 
