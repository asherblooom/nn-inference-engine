#include <fstream>
#include <iostream>
// #include <string>

#include "onnx-ml.pb.h"

int main(int argc, char* argv[]) {
	GOOGLE_PROTOBUF_VERIFY_VERSION;

	if (argc != 2) {
		std::cerr << "Usage:  " << argv[0] << " MODEL_FILE\n";
		return -1;
	}

	onnx::ModelProto model_proto;
	{
		std::fstream input(argv[1], std::ios::in | std::ios::binary);
		if (!input) {
			std::cout << argv[1] << ": File not found.  Creating a new file.\n";
		} else if (!model_proto.ParseFromIstream(&input)) {
			std::cerr << "Failed to parse the ONNX model.\n";
			return -1;
		}
	}

	onnx::GraphProto graph_proto = model_proto.graph();
	for (onnx::NodeProto node : graph_proto.node()) {
		std::cout << node.name() << "\n";
	}

	return 0;
}
