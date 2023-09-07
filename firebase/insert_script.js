var XLSX = require("xlsx");
const { v4: uuidv4 } = require("uuid");

var workbook = XLSX.readFile("data.xlsx");
var jsa = XLSX.utils.sheet_to_json(workbook.Sheets["Sheet1"]);

const { initializeApp, applicationDefault } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");

const app = initializeApp({
  credential: applicationDefault(),
});
const db = getFirestore(app);

Promise.all(
  jsa.map((e) =>
    db
      .collection("car_types")
      .doc()
      .set({ uid: uuidv4(), ...e })
  )
)
  .then(() => console.log("done"))
  .catch((err) => console.log(err));
