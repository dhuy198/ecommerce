import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["cartContainer"];

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
    const btn = document.getElementById("onlogin");
    navbar.innerText = cart.length || "0";
    const container = document.getElementById("cart-container");
    if (!container) return;

    if (cart.length === 0) {
      container.innerHTML = `
        <p class="text-center text-gray-500 mt-10">Your cart is empty.</p>
      `;
      btn.classList.add("hidden");
      return;
    }
    btn.classList.remove("hidden");

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
              data-id="${item.id}"
              data-stock="${item.stock}"
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

    let subtotal = cart.reduce(
      (sum, item) => sum + item.price * item.quantity,
      0
    );

    const taxElement = document.getElementById("tax");
    const taxRate = taxElement ? parseFloat(taxElement.dataset.tax) : 0;
    const taxAmount = (subtotal * taxRate) / 100;
    const totalWithTax = subtotal + taxAmount;

    container.innerHTML += `
  <div class="border border-gray-200 rounded-xl p-8 shadow-sm bg-white h-fit md:col-span-1 cols-span-1 mt-6">
    <h2 class="text-xl font-semibold mb-6 text-gray-800">Cart Totals</h2>
    <!-- Subtotal -->
    <div class="flex justify-between mb-3 text-sm text-gray-600">
      <span>Subtotal</span>
      <span id="total1">$${subtotal.toFixed(2)}</span>
    </div>
    <!-- Tax -->
    ${
      taxRate > 0
        ? `
      <div class="flex justify-between mb-3 text-sm text-gray-600">
        <span>Tax (${taxRate}%)</span>
        <span id="tax">$${taxAmount.toFixed(2)}</span>
      </div>`
        : ""
    }
    <!-- Divider -->
    <hr class="my-4">
    <!-- Total -->
    <div class="flex justify-between text-base font-bold text-gray-800 mb-6">
      <span>Total</span>
      <span id="total2">$${totalWithTax.toFixed(2)}</span>
    </div>
  </div>
`;

    this.attachQuantityEvents();
    this.attachRemoveEvents();
  }

  attachQuantityEvents() {
    const container = document.getElementById("cart-container");

    container.querySelectorAll(".qty-up").forEach((btn) => {
      btn.addEventListener("click", () => {
        const id = btn.closest("[data-id]").dataset.id;
        this.updateQuantity(id, 1);
      });
    });

    container.querySelectorAll(".qty-down").forEach((btn) => {
      btn.addEventListener("click", () => {
        const id = btn.closest("[data-id]").dataset.id;
        this.updateQuantity(id, -1);
      });
    });
  }

  updateQuantity(id, delta) {
    let cart = JSON.parse(localStorage.getItem("cart")) || [];
    const index = cart.findIndex((item) => String(item.id) === String(id));
    if (index !== -1) {
      let quantity = cart[index].quantity + delta;
      if (quantity < 1) quantity = 1;
      cart[index].quantity = quantity;
      localStorage.setItem("cart", JSON.stringify(cart));
      this.connect(); // re-render cart
    }
  }

  attachRemoveEvents() {
    const container = document.getElementById("cart-container");
    container.querySelectorAll(".remove-btn").forEach((btn) => {
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
