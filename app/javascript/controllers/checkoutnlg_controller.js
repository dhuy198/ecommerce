// app/javascript/controllers/checkoutnlg_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "name",
    "email",
    "phone",
    "address",
    "city",
    "country",
    "errors",
  ];

  connect() {
    const cart = localStorage.getItem("cart") || "[]";
    console.log(cart);
  }
  send(event) {
    event.preventDefault();
    const cartItems = localStorage.getItem("cart_items") || "[]";

    document.getElementById("cart-items-field").value = cartItems;
    const full_name = this.nameTarget.value;
    const phone_number = this.phoneTarget.value;
    const address = this.addressTarget.value;
    const city = this.cityTarget.value;
    const country = this.countryTarget.value;
    const email = this.emailTarget.value;

    const errors = [];

    if (!email.trim() || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
      errors.push("Please enter a valid email address.");
    }

    if (!full_name.trim() || !/^[a-zA-ZÀ-ỹ\s]{2,50}$/.test(full_name)) {
      errors.push(
        "Name must be at least 2 letters and only contain letters/spaces."
      );
    }
    if (!phone_number.trim() || !/^\d{9,11}$/.test(phone_number)) {
      errors.push("Phone must be 9–11 digits.");
    }
    if (!address.trim() || address.length < 5) {
      errors.push("Address must be at least 5 characters.");
    }
    if (!city.trim()) {
      errors.push("Please enter your city");
    }
    if (!country.trim()) {
      errors.push("Please enter your country");
    }

    if (errors.length > 0) {
      this.showErrors(errors);
      return;
    }

    this.element.submit();
  }

  showErrors(errors) {
    this.errorsTarget.innerHTML = errors
      .map((e) => `<p class="text-red-500 text-sm">${e}</p>`)
      .join("");
    this.errorsTarget.classList.remove("hidden");
  }
}
