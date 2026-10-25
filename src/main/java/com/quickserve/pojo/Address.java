package com.quickserve.pojo;

public class Address {
    private int addressId;
    private int userId;
    private String addressLine;
    private String city;
    private String state;
    private String pincode;
    private boolean isDefault;

    public Address() {}

    public Address(int addressId, int userId, String addressLine, String city, String state, String pincode, boolean isDefault) {
        this.addressId = addressId;
        this.userId = userId;
        this.addressLine = addressLine;
        this.city = city;
        this.state = state;
        this.pincode = pincode;
        this.isDefault = isDefault;
    }

    public int getAddressId() { return addressId; }
    public void setAddressId(int addressId) { this.addressId = addressId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getAddressLine() { return addressLine; }
    public void setAddressLine(String addressLine) { this.addressLine = addressLine; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    public String getPincode() { return pincode; }
    public void setPincode(String pincode) { this.pincode = pincode; }

    public boolean isDefault() { return isDefault; }
    public void setDefault(boolean isDefault) { this.isDefault = isDefault; }

    public String getFormattedAddress() {
        StringBuilder sb = new StringBuilder();
        if (addressLine != null) sb.append(addressLine);
        if (city != null) sb.append(", ").append(city);
        if (state != null) sb.append(", ").append(state);
        if (pincode != null) sb.append(" - ").append(pincode);
        return sb.toString();
    }
}
