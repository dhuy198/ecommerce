import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["text"];
  add() {
    const cartId = this.element.dataset.cartId;
    const productId = this.element.dataset.productId;

    const params = {
      cart_id: cartId,
      product_id: productId,
      quantity: 1,
    };
    const options = {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(params),
    };
    fetch("/api/v1/cart_items", options)
      .then((res) => {
        if (!res.ok) {
          throw Error(res.status);
        }
        return res.json();
      })
      .then((data) => {
        this.element.outerHTML = `
            <a href="/cart"
                class="flex-1 bg-[#152420] cursor-pointer text-white font-semibold py-3 px-6 rounded-xl hover:bg-[#152420] transform hover:scale-105 transition-all duration-200 shadow-lg hover:shadow-xl flex items-center justify-center space-x-2">
                <span class="mr-2"></span>View Cart
            </a>
            `;

        const navbar = document.getElementById("cartCount");
        navbar.innerText = data.total_product_id;
        navbar.dataset.cartCount = data.total_product_id;

        console.log(data);
      })
      .catch((e) => {
        console.log(e);
      });
  }
}
