import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(PayCalculator());
}

class PayCalculator extends StatelessWidget {
  const PayCalculator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Pay Calculator",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.indigo,
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: EdgeInsets.fromLTRB(0, 50, 0, 20),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Text(
                  "Please enter your details",
                  style: TextStyle(
                    color: Colors.deepOrangeAccent,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                FormInputs(), // Ensure FormInputs is defined
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FormInputs extends StatefulWidget {
  const FormInputs({super.key});

  @override
  _FormInputs createState() => _FormInputs();
}

class _FormInputs extends State<FormInputs> {
  double? _regularPay;
  double? _overTimePay;
  double? _totalPay;
  double? _tax;

  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();

  // Method to calculate pay
  void _calculatePay() {
    final double hours = double.tryParse(_hoursController.text) ?? 0;
    final double rate = double.tryParse(_rateController.text) ?? 0;

    setState(() {
      if (hours <= 40) {
        _totalPay = hours * rate;
        _regularPay = hours * rate;
        _overTimePay = 0.0;
      } else {
        _totalPay = (hours - 40) * rate * 1.5 + 40 * rate;
        _regularPay = 40 * rate;
        _overTimePay = (hours - 40) * rate * 1.5;
        // _regularPay = hours * rate;
      }
      // _regularPay = hours * rate; // Regular pay calculation
      // _overTimePay = hours > 40
      //     ? (hours - 40) * (rate * 1.5)
      //     : 0; // Overtime pay calculation
      // _totalPay = (_regularPay ?? 0) + (_overTimePay ?? 0); // Total pay
      _tax = _totalPay! * 0.18;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: _hoursController,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "No. of hrs worked/week",
                labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter(RegExp(r'^\d*\.?\d*$'),
                    allow: true),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _rateController,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "Hourly Rate",
                labelStyle: TextStyle(fontSize: 16, color: Colors.grey[700]),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.indigo),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter(RegExp(r'^\d*\.?\d*$'),
                    allow: true),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _calculatePay,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Calculate",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(),
            const SizedBox(height: 16),
            _regularPay != null &&
                    _overTimePay != null &&
                    _totalPay != null &&
                    _tax != null
                ? Result(
                    regularPay: _regularPay!,
                    overTimePay: _overTimePay!,
                    totalPay: _totalPay!,
                    tax: _tax!,
                  )
                : Center(
                    child: Text(
                      "Result will appear here.",
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
          ],
        ));
  }
}

class Result extends StatefulWidget {
  final double regularPay;
  final double overTimePay;
  final double totalPay;
  final double tax;

  const Result(
      {super.key,
      required this.regularPay,
      required this.overTimePay,
      required this.totalPay,
      required this.tax});

  @override
  _Result createState() => _Result();
}

class _Result extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          CustomCard(
              text: "Regular Pay",
              amount: widget.regularPay,
              cardColor: Colors.indigo,
              amountColor: Colors.white),
          const SizedBox(height: 10),
          CustomCard(
              text: "Overtime Pay",
              amount: widget.overTimePay,
              cardColor: Colors.orange,
              amountColor: Colors.white),
          const SizedBox(height: 10),
          CustomCard(
              text: "Total Pay (Before Tax)",
              amount: widget.totalPay,
              cardColor: Colors.teal,
              amountColor: Colors.white),
          const SizedBox(height: 10),
          CustomCard(
              text: "Tax",
              amount: widget.tax,
              cardColor: Colors.red,
              amountColor: Colors.white),
        ],
      ),
    );
  }
}

class CustomCard extends StatefulWidget {
  final String text;
  final double amount;
  final Color cardColor;
  final Color amountColor;

  const CustomCard({
    Key? key,
    required this.text,
    required this.amount,
    required this.cardColor,
    required this.amountColor,
  }) : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      color: widget.cardColor,
      child: ListTile(
        title: Text(
          widget.text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          "\$${widget.amount.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 16,
            color: widget.amountColor,
          ),
        ),
      ),
    );
  }
}
