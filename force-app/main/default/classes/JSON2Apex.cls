public with sharing class JSON2Apex {
    
    public List<Items> items;

    public class Items{
        // successful request fields
        public String phoneNumber;
        public Boolean requestProcessed;
        public String isValid;
        public String networkCode;
        public String networkName;
        public String networkCountry;
        public String nationalFormat;
        public Integer countryPrefix;
        public String numberType;
        //ussuccessful request fields
        public Integer error;
        public String description;
        public String cause;
        public String resolution;
    }

    public static JSON2Apex parse(String json) {
        return (JSON2Apex) System.JSON.deserialize(json, JSON2Apex.class);
    }
}