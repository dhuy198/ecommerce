import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  add() {
    let cart = JSON.parse(localStorage.getItem("cart")) || [];
    const productId = this.element.dataset.productId;
    const name = this.element.dataset.productName;
    const price = parseFloat(this.element.dataset.productPrice);
    const category_name = this.element.dataset.categoryName;
    const imageUrl = this.element.dataset.imageUrl;
    const stock = this.element.dataset.stock;

    const params = {
      id: productId,
      name: name,
      price: price,
      category_name: category_name,
      stock: stock,
      image_url: imageUrl,
      quantity: 1,
    };
    const existsP = cart.find((item) => item.id === productId);
    if (existsP) {
      existsP.quantity += 1;
    } else {
      cart.push(params);
    }
    localStorage.setItem("cart", JSON.stringify(cart));
    this.element.outerHTML = `
            <a href="/cart"
                class="flex-1 bg-[#152420] cursor-pointer text-white font-semibold py-3 px-6 rounded-xl hover:bg-[#152420] transform hover:scale-105 transition-all duration-200 shadow-lg hover:shadow-xl flex items-center justify-center space-x-2">
                <span class="mr-2"></span>View Cart
            </a>
            `;

    const navbar = document.getElementById("cnloginCount");
    navbar.innerText = cart.length;
  }

  connect() {
    let cart = JSON.parse(localStorage.getItem("cart")) || [];
    const navbar = document.getElementById("cnloginCount");
    navbar.innerText = cart.length || "0";
    const container = document.getElementById("cart-container");
    if (!container) return;
    if (cart.length === 0) {
      container.innerHTML = `
          <p class="text-center text-gray-500 mt-10">Your cart is empty.</p>
        `;
      return;
    }

    container.innerHTML = cart
      .map(
        (item) => `
        <div class="grid grid-cols-12 gap-4 items-center p-4 border border-gray-200 rounded-xl shadow-sm bg-white hover:shadow-md transition">
          <!-- Image -->
          <div class="col-span-2">
            <img src="${item.image_url}" alt="${
          item.name
        }" class="w-20 h-20 object-cover rounded-lg shadow">
          </div>

          <!-- Product Name + Price -->
          <div class="col-span-4">
            <div class="font-semibold text-gray-800 text-base">${
              item.name
            }</div>
            <div class="text-gray-500 text-sm mt-1">$${item.price.toFixed(
              2
            )}</div>
          </div>

          <!-- Quantity -->
          <div class="col-span-3">
            <div
              class="inline-flex items-center border border-gray-300 rounded-full px-4 py-1 bg-white"
              data-controller="quantity"
              data-id="${item.id}"
              data-stock="${item.stock}"
              data-item-quantity="${item.quantity}>"
            >
              <button class="qty-down px-3 text-lg text-gray-600 hover:text-black">-</button>
              <span id="qty-${item.id}" class="px-4 text-sm text-gray-800">${
          item.quantity
        }</span>
              <button class="qty-up px-3 text-lg text-gray-600 hover:text-black">+</button>
            </div>
          </div>

          <!-- Subtotal -->
          <div class="col-span-2 text-sm text-gray-800 font-medium" id="subtotal-${
            item.id
          }">
            $${(item.price * item.quantity).toFixed(2)}
          </div>
          
          

          <!-- Remove -->
          <div class="col-span-1 text-right">
            <button data-id="${
              item.id
            }" class="remove-btn text-gray-400 pr-4 text-sm cursor-pointer hover:text-red-500">
              <i class="fas fa-trash"></i>
            </button>
          </div>
        </div>
      `
      )
      .join("");
  }

  attachRemoveEvents() {
    const container = document.getElementById("cart-container");
    const buttons = container.querySelectorAll(".remove-btn");

    buttons.forEach((btn) => {
      btn.addEventListener("click", () => {
        const productId = btn.dataset.id;
        let cart = JSON.parse(localStorage.getItem("cart")) || [];
        cart = cart.filter((item) => String(item.id) !== String(productId));
        localStorage.setItem("cart", JSON.stringify(cart));
        this.connect();
      });
    });
  }
}
