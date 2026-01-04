import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:djorder/features/order/model/order.dart';
import 'package:printing/printing.dart';

class PrintOrderService {
  Future<void> generateAndPrintOrder(Order order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text(
                  'COMANDA #${order.idOrder}',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(flex: 1, child: pw.Text('Cliente:')),
                  pw.Expanded(
                    flex: 3,
                    child: pw.Text(
                      '${order.clientName}',
                      textAlign: pw.TextAlign.right,
                      maxLines: 2,
                      overflow: pw.TextOverflow.clip,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 2),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  if (order.idTable! > 0)
                    pw.Text(
                      'Mesa: ${order.idTable}',
                      style: pw.TextStyle(fontSize: 10),
                    ),
                  // mock
                  pw.Text('N° Pessoas: 1', style: pw.TextStyle(fontSize: 10)),
                ],
              ),
              pw.Text(
                'Hora Abertura: ${order.oppeningDate.hour}:${order.oppeningDate.minute}:${order.oppeningDate.second}',
                style: pw.TextStyle(fontSize: 10),
                textAlign: pw.TextAlign.end,
              ),

              pw.Divider(),

              ...order.products.map((item) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          '${item.qtd.toInt()} x ${item.description}',
                          style: pw.TextStyle(fontSize: 10),
                          maxLines: 2,
                          overflow: pw.TextOverflow.clip,
                        ),
                      ],
                    ),

                    if (item.additional.isNotEmpty)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 8, top: 2),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: item.additional
                              .map(
                                (add) => pw.Text(
                                  add.qtd.toInt() > 1
                                      ? '+${add.qtd.toInt()} ${add.description}'
                                      : '+  ${add.description}',
                                  style: pw.TextStyle(
                                    fontSize: 7,
                                    fontStyle: pw.FontStyle.italic,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    pw.SizedBox(height: 4),
                  ],
                );
              }),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
