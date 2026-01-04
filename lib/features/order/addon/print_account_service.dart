import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:djorder/features/order/model/order.dart';

class PrintAccountService {
  Future<void> generateAndPrintAccount(Order order) async {
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
                      style: pw.TextStyle(fontSize: 8),
                    ),
                  pw.Text('N° Pessoas: 1', style: pw.TextStyle(fontSize: 8)),
                  /*pw.Text('N° Pessoas: ${order.peopleNumber}', style: pw.TextStyle(fontSize: 10)*/
                ],
              ),
              pw.Row(
                children: [
                  pw.Expanded(
                    flex: 2,
                    child: pw.Text(
                      'Hora Abertura: ${order.oppeningDate.hour}:${order.oppeningDate.minute}:${order.oppeningDate.second}',
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.start,
                    ),
                  ),
                  pw.Expanded(
                    flex: 1,
                    child: pw.Text(
                      'Data: ${order.oppeningDate.day}/${order.oppeningDate.month}/${order.oppeningDate.year}',
                      style: pw.TextStyle(fontSize: 8),
                      textAlign: pw.TextAlign.end,
                    ),
                  ),
                ],
              ),

              pw.Divider(),

              ...order.products.map((item) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    if (item.status == 'N')
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            flex: 3,
                            child: pw.Text(
                              '${item.qtd.toInt()} x ${item.description}',
                              style: pw.TextStyle(fontSize: 10),
                              maxLines: 2,
                              overflow: pw.TextOverflow.clip,
                            ),
                          ),
                          pw.Expanded(
                            flex: 1,
                            child: pw.Text(
                              'R\$ ${(item.price * item.qtd).toStringAsFixed(2)}',
                              textAlign: pw.TextAlign.right,
                              style: pw.TextStyle(fontSize: 8),
                            ),
                          ),
                        ],
                      ),
                    if (item.status == 'N' && item.additional.isNotEmpty)
                      pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 8, top: 2),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: item.additional.map((add) {
                            return pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Expanded(
                                      flex: 3,
                                      child: pw.Text(
                                        add.qtd.toInt() > 1
                                            ? '+${add.qtd.toInt()} ${add.description}'
                                            : '+  ${add.description}',
                                        style: pw.TextStyle(
                                          fontSize: 7,
                                          fontStyle: pw.FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                    if (add.price > 0 && add.qtd > 0)
                                      pw.Expanded(
                                        flex: 1,
                                        child: pw.Text(
                                          'R\$ ${(add.price * add.qtd).toStringAsFixed(2)}',
                                          textAlign: pw.TextAlign.right,
                                          style: pw.TextStyle(fontSize: 8),
                                        ),
                                      ),
                                    if (add.price > 0 && add.qtd == 0)
                                      pw.Expanded(
                                        flex: 1,
                                        child: pw.Text(
                                          'R\$ ${add.price.toStringAsFixed(2)}',
                                          textAlign: pw.TextAlign.right,
                                          style: pw.TextStyle(fontSize: 8),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),

                    pw.SizedBox(height: 4),
                  ],
                );
              }),

              pw.Divider(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      'Subtotal: R\$ ${order.subtotal.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Taxa de Servico: R\$ ${order.serviceTax.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Valor por pessoa: R\$ ${(order.totalValue / 2 /*order.peopleNumber*/ ).toStringAsFixed(2).replaceAll('.', ',')}',
                      style: pw.TextStyle(fontSize: 8),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      'Total: R\$ ${order.totalValue.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
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
