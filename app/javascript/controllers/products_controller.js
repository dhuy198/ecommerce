import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const input = document.getElementById("product_image");
    const nameSpan = document.getElementById("selected-image-name");

    if (input && nameSpan) {
      input.addEventListener("change", () => {
        if (input.files && input.files[0]) {
          nameSpan.textContent = input.files[0].name;
        } else {
          nameSpan.textContent = "";
        }
      });
    }
  }
}
