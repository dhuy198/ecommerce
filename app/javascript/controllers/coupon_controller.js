import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  add() {
    const code = document.getElementById("coupon_code");
    const total = this.element.dataset.total;
    const message = document.getElementById("coupon_message");
    const mgg = document.getElementById("mgg");
    fetch("/api/v1/coupons/apply", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        code: code.value,
        cart_total: Number(total),
      }),
    })
      .then((res) => res.json())
      .then((data) => {
        if (data.success) {
          document.getElementById("total2").innerHTML = `$${data.cart_total}`;
          message.classList.add("hidden");
          const mggText = document.createElement("p");
          mggText.innerText = `Your Order was reduced ${data.discount_percentage}%`;
          mggText.className =
            "mt-3 p-3 rounded-lg text-sm font-medium bg-green-100 text-green-800 border border-green-300 shadow-sm";

          mgg.appendChild(mggText);
          document.getElementById("coupon_code").disabled = true;
          document.getElementById("apply_coupon").disabled = true;

          document
            .getElementById("apply_coupon")
            .classList.add("opacity-50", "cursor-not-allowed");
        } else {
          message.innerText = data.message;
          message.classList.remove("hidden");
        }
      });
  }
}
