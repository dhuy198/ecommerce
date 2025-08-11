import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["cardForm", "codForm"];

  toggle(event) {
    const selected = event.target.value;
    const credit = document.getElementById("credit_card");
    if (selected === "card") {
      this.cardFormTarget.classList.remove("hidden");
      this.codFormTarget.classList.add("hidden");
      credit.classList.remove("hidden");
    } else if (selected === "cod") {
      this.cardFormTarget.classList.add("hidden");
      this.codFormTarget.classList.remove("hidden");
      credit.classList.add("hidden");
    }
  }
}
