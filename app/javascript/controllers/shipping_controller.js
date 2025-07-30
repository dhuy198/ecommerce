import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = [
    "name",
    "phone",
    "address",
    "city",
    "district",
    "postal",
    "country",
    "errors",
  ];
  send() {
    const url = this.element.dataset.url;
    const method = this.element.dataset.method;

    const params = {
      full_name: this.nameTarget.value,
      phone_number: this.phoneTarget.value,
      address: this.addressTarget.value,
      city: this.cityTarget.value,
      district: this.districtTarget.value,
      postal_code: this.postalTarget.value,
      country: this.countryTarget.value,
    };
    const options = {
      method: method,
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(params),
    };
    fetch(url, options)
      .then(async (res) => {
        const data = await res.json();

        if (!res.ok) {
          this.showErrors(data.errors || ["Có lỗi xảy ra."]);
          throw new Error(`HTTP ${res.status}`);
        }

        this.clearErrors();
        console.log("Tạo địa chỉ thành công:", data);
        window.location.href = "/cart";
      })
      .catch((e) => {
        console.error("Lỗi gửi request:", e);
      });
  }
  showErrors(messages) {
    this.errorsTarget.innerHTML = `
      <h2 class="font-bold mb-2">Đã có lỗi:</h2>
      <ul class="list-disc pl-5 space-y-1">
        ${messages.map((msg) => `<li>${msg}</li>`).join("")}
      </ul>
    `;
    this.errorsTarget.classList.remove("hidden");
  }

  clearErrors() {
    this.errorsTarget.classList.add("hidden");
    this.errorsTarget.innerHTML = "";
  }
}
