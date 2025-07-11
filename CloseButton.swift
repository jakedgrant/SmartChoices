Button {
						dismiss()
					} label: {
						Image(systemName: "xmark")
							.imageScale(.small)
					}
					.buttonStyle(SCCircleButtonStyle(padding: 12))
					.padding(.trailing, -12)