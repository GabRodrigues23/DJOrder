import 'package:djorder/features/order/model/order.dart';
import 'package:djorder/shared/enums/menu_options_type.dart';
import 'package:djorder/shared/enums/order_status_type.dart';
import 'package:djorder/shared/extensions/order_status_extension.dart';

extension MenuOptionsExtension on MenuOption {
  static List<MenuOption> getOptionsFor(Order order) {
    final status = order.calculatedStatus;
    if (status == OrderStatus.free) {
      return [MenuOption.addProduct];
    }

    if (status == OrderStatus.lock) {
      return [MenuOption.unblock];
    }

    return [
      MenuOption.addProduct,
      (order.clientName == null ||
              order.clientName!.isEmpty ||
              order.clientName! == 'VENDAS AO CONSUMIDOR')
          ? MenuOption.addClient
          : MenuOption.changeClient,
      (order.idTable == null || order.idTable == 0)
          ? MenuOption.addTable
          : MenuOption.changeTable,
      MenuOption.changePeopleCount,
      MenuOption.printOrder,
      MenuOption.printAccount,
      // MenuOption.finalize,
      MenuOption.block,
      MenuOption.cancel,
    ];
  }
}
