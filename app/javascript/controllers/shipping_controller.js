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

    const full_name = this.nameTarget.value;
    const phone_number = this.phoneTarget.value;
    const address = this.addressTarget.value;
    const city = this.cityTarget.value;
    const district = this.districtTarget.value;
    const postal_code = this.postalTarget.value;
    const country = this.countryTarget.value;
    const params = {
      full_name: full_name,
      phone_number: phone_number,
      address: address,
      city: city,
      district: district,
      postal_code: postal_code,
      country: country,
    };

    const errors = [];
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
    if (!district.trim()) {
      errors.push("Please enter your district");
    }
    if (!postal_code.trim() || !/^\d{5,6}$/.test(postal_code)) {
      errors.push("Please enter a valid postal code");
    }
    if (!country.trim()) {
      errors.push("Please enter your coutry");
    }

    if (errors.length > 0) {
      this.showErrors(errors);
      return;
    }

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
        this.clearErrors();
        console.error("Lỗi gửi request:", e);
      });
  }
  showErrors(messages) {
    this.errorsTarget.innerHTML = `
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
