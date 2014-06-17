#include <QDir>
class path : public QObject {
	Q_OBJECT
public:
	Q_INVOKABLE QString homeDir();
};
